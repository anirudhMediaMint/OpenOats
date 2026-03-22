import Testing
@testable import OpenOatsKit

@Suite("TranscriptionModel enum")
struct TranscriptionModelTests {
    @Test("has six cases")
    func allCases() {
        #expect(TranscriptionModel.allCases.count == 6)
        #expect(TranscriptionModel.allCases.contains(.parakeetV2))
        #expect(TranscriptionModel.allCases.contains(.parakeetV3))
        #expect(TranscriptionModel.allCases.contains(.qwen3ASR06B))
        #expect(TranscriptionModel.allCases.contains(.whisperBase))
        #expect(TranscriptionModel.allCases.contains(.whisperSmall))
        #expect(TranscriptionModel.allCases.contains(.mlxQwen3ASR))
    }

    @Test("raw values are stable for UserDefaults persistence")
    func rawValues() {
        #expect(TranscriptionModel.parakeetV2.rawValue == "parakeetV2")
        #expect(TranscriptionModel.parakeetV3.rawValue == "parakeetV3")
        #expect(TranscriptionModel.qwen3ASR06B.rawValue == "qwen3ASR06B")
        #expect(TranscriptionModel.whisperBase.rawValue == "whisperBase")
        #expect(TranscriptionModel.whisperSmall.rawValue == "whisperSmall")
        #expect(TranscriptionModel.mlxQwen3ASR.rawValue == "mlxQwen3ASR")
    }

    @Test("display names are user-facing strings")
    func displayNames() {
        #expect(TranscriptionModel.parakeetV2.displayName == "Parakeet TDT v2")
        #expect(TranscriptionModel.parakeetV3.displayName == "Parakeet TDT v3")
        #expect(TranscriptionModel.qwen3ASR06B.displayName == "Qwen3 ASR 0.6B")
        #expect(TranscriptionModel.whisperBase.displayName == "Whisper Base")
        #expect(TranscriptionModel.whisperSmall.displayName == "Whisper Small")
        #expect(TranscriptionModel.mlxQwen3ASR.displayName == "MLX Qwen3 ASR 1.7B")
    }

    @Test("round-trips through raw value")
    func roundTrip() {
        for model in TranscriptionModel.allCases {
            #expect(TranscriptionModel(rawValue: model.rawValue) == model)
        }
    }

    @Test("invalid raw value returns nil")
    func invalidRawValue() {
        #expect(TranscriptionModel(rawValue: "nonexistent") == nil)
    }

    @Test("mlxQwen3ASR supports language hint")
    func mlxQwen3ASRSupportsLanguageHint() {
        #expect(TranscriptionModel.mlxQwen3ASR.supportsExplicitLanguageHint == true)
    }

    @Test("mlxQwen3ASR download prompt mentions size")
    func mlxQwen3ASRDownloadPrompt() {
        let prompt = TranscriptionModel.mlxQwen3ASR.downloadPrompt
        #expect(prompt.contains("1.7 GB"))
    }

    @Test("all cases have non-empty computed properties")
    func nonEmptyProperties() {
        for model in TranscriptionModel.allCases {
            #expect(!model.displayName.isEmpty)
            #expect(!model.downloadPrompt.isEmpty)
            #expect(!model.localeFieldTitle.isEmpty)
            #expect(!model.localeHelpText.isEmpty)
        }
    }
}

@Suite("TranscriptionEngineError")
struct TranscriptionEngineErrorTests {
    @Test("provides localized description for each model")
    func localizedDescriptions() {
        for model in TranscriptionModel.allCases {
            let error = TranscriptionEngineError.transcriberNotInitialized(model)
            let desc = error.localizedDescription
            #expect(desc.contains(model.displayName))
            #expect(desc.contains("not initialized"))
        }
    }
}
