import Foundation
import MLX
import MLXAudioSTT

/// Transcription backend for Qwen3 ASR 1.7B via MLX (on-device, Apple Silicon).
/// @unchecked Sendable: model is written once in prepare() before any transcribe() calls.
final class MLXBackend: TranscriptionBackend, @unchecked Sendable {
    let displayName = "MLX Qwen3 ASR 1.7B"
    private var model: Qwen3ASRModel?

    private static let hubModelID = "mlx-community/Qwen3-ASR-1.7B-8bit"

    func checkStatus() -> BackendStatus {
        // MLX requires its Metal shader library (mlx.metallib) to be colocated
        // with the binary. SPM builds don't produce this automatically — only
        // Xcode builds do. Check for it before allowing model use.
        if !Self.metalLibAvailable {
            return .needsDownload(
                prompt: "MLX Qwen3 ASR is not yet supported in standalone app builds. Metal shader library is missing. Please use a different transcription model."
            )
        }

        let cacheDir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".cache/huggingface/hub")
        let modelDir = cacheDir.appendingPathComponent(
            "models--\(Self.hubModelID.replacingOccurrences(of: "/", with: "--"))"
        )
        let exists = FileManager.default.fileExists(atPath: modelDir.path)
        return exists ? .ready : .needsDownload(
            prompt: "MLX Qwen3 ASR 1.7B requires a one-time model download (~1.7 GB)."
        )
    }

    /// Check whether the MLX Metal shader library is accessible.
    private static var metalLibAvailable: Bool {
        let fm = FileManager.default
        let binaryDir = Bundle.main.executableURL?.deletingLastPathComponent()
        let candidates = [
            binaryDir?.appendingPathComponent("mlx.metallib"),
            binaryDir?.appendingPathComponent("Resources/mlx.metallib"),
            binaryDir?.appendingPathComponent("default.metallib"),
            binaryDir?.appendingPathComponent("Resources/default.metallib"),
        ]
        return candidates.contains { $0.map { fm.fileExists(atPath: $0.path) } ?? false }
    }

    func clearModelCache() {
        let cacheDir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".cache/huggingface/hub")
        let modelDir = cacheDir.appendingPathComponent(
            "models--\(Self.hubModelID.replacingOccurrences(of: "/", with: "--"))"
        )
        try? FileManager.default.removeItem(at: modelDir)
    }

    func prepare(onStatus: @Sendable (String) -> Void) async throws {
        onStatus("Downloading \(displayName)...")
        let loaded = try await Qwen3ASRModel.fromPretrained(Self.hubModelID)
        self.model = loaded
        onStatus("\(displayName) ready")
    }

    func transcribe(_ samples: [Float], locale: Locale, previousContext: String? = nil) async throws -> String {
        guard let model else {
            throw TranscriptionBackendError.notPrepared
        }

        let audioArray = MLXArray(samples)
        let language = Self.languageName(for: locale)
        let output = model.generate(audio: audioArray, language: language)
        return output.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Map a Locale to the English language name expected by Qwen3 ASR.
    private static func languageName(for locale: Locale) -> String {
        let identifier = locale.identifier.replacingOccurrences(of: "_", with: "-")
        guard let code = identifier.split(separator: "-").first.map({ String($0).lowercased() }) else {
            return "English"
        }
        let mapping: [String: String] = [
            "en": "English", "zh": "Chinese", "ja": "Japanese",
            "ko": "Korean", "fr": "French", "de": "German",
            "es": "Spanish", "pt": "Portuguese", "it": "Italian",
            "ru": "Russian", "ar": "Arabic", "hi": "Hindi",
            "th": "Thai", "vi": "Vietnamese", "tr": "Turkish",
            "nl": "Dutch", "pl": "Polish", "sv": "Swedish",
            "da": "Danish", "fi": "Finnish", "cs": "Czech",
            "el": "Greek", "hu": "Hungarian", "ro": "Romanian",
            "id": "Indonesian", "ms": "Malay", "fa": "Persian",
        ]
        return mapping[code] ?? "English"
    }
}
