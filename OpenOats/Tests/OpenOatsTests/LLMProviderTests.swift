import Testing
@testable import OpenOatsKit

@Suite("LLMProvider enum")
struct LLMProviderTests {
    @Test("has four cases")
    func allCases() {
        #expect(LLMProvider.allCases.count == 4)
        #expect(LLMProvider.allCases.contains(.openRouter))
        #expect(LLMProvider.allCases.contains(.ollama))
        #expect(LLMProvider.allCases.contains(.mlx))
        #expect(LLMProvider.allCases.contains(.openAICompatible))
    }

    @Test("raw values are stable for UserDefaults persistence")
    func rawValues() {
        #expect(LLMProvider.openRouter.rawValue == "openRouter")
        #expect(LLMProvider.ollama.rawValue == "ollama")
        #expect(LLMProvider.openAICompatible.rawValue == "openAICompatible")
    }

    @Test("display names are user-facing strings")
    func displayNames() {
        #expect(LLMProvider.openRouter.displayName == "OpenRouter")
        #expect(LLMProvider.ollama.displayName == "Ollama")
        #expect(LLMProvider.openAICompatible.displayName == "OpenAI Compatible")
    }

    @Test("round-trips through raw value")
    func roundTrip() {
        for provider in LLMProvider.allCases {
            #expect(LLMProvider(rawValue: provider.rawValue) == provider)
        }
    }

    @Test("invalid raw value returns nil")
    func invalidRawValue() {
        #expect(LLMProvider(rawValue: "nonexistent") == nil)
    }
}
