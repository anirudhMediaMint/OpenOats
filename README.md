# OpenGranola

A meeting note-taker that talks back.

OpenGranola sits next to your call, transcribes both sides of the conversation in real time, and searches your own notes to surface things worth saying — right when you need them.

Think of it as Granola on steroids: it doesn't just take notes, it reads the room, digs through your knowledge base, and hands you the perfect talking point before the moment passes.

<p align="center">
  <img src="assets/screenshot.png" width="360" alt="OpenGranola during an investor call — suggestions drawn from your own notes appear at the top, live transcript below" />
</p>

## Features

- **Invisible to the other side** — the app window is hidden from screen sharing by default, so no one knows you're using it
- **Fully offline transcription** — speech recognition runs entirely on your Mac; no audio ever leaves the device
- **Runs 100% locally** — pair with [Ollama](https://ollama.com/) for LLM suggestions and local embeddings, and nothing touches the network at all
- **Pick any LLM** — use [OpenRouter](https://openrouter.ai/) for cloud models (GPT-4o, Claude, Gemini) or Ollama for local ones (Llama, Qwen, Mistral)
- **Live transcript** — see both sides of the conversation as it happens, copy the whole thing with one click
- **Auto-saved sessions** — every conversation is automatically saved as a plain-text transcript and a structured session log, no manual export needed
- **Knowledge base search** — point it at a folder of notes and it pulls in what's relevant using [Voyage AI](https://www.voyageai.com/) embeddings or local Ollama embeddings

## How it works

1. You start a call and hit **Live**
2. OpenGranola transcribes both speakers locally on your Mac
3. When the conversation hits a moment that matters — a question, a decision point, a claim worth backing up — it searches your notes and surfaces relevant talking points
4. You sound prepared because you are

## Download

Grab the latest DMG from the [Releases page](https://github.com/yazinsai/OpenGranola/releases/latest).

Or build from source:

```bash
./scripts/build_swift_app.sh
```

## Quick start

1. Open the DMG and drag OpenGranola to Applications
2. Launch the app and grant microphone + screen capture permissions
3. Open Settings (`Cmd+,`) and pick your providers:
   - **Cloud**: add your OpenRouter and Voyage AI API keys
   - **Local**: select Ollama as your LLM and embedding provider (make sure Ollama is running)
4. Point it at a folder of `.md` or `.txt` files — that's your knowledge base
5. Click **Idle** to go live

The first run downloads the local speech model (~600 MB).

## What you need

- Apple Silicon Mac, macOS 26+
- Xcode 26 / Swift 6.2
- **For cloud mode**: [OpenRouter](https://openrouter.ai/) API key + [Voyage AI](https://www.voyageai.com/) API key
- **For local mode**: [Ollama](https://ollama.com/) running locally with your preferred models (e.g. `qwen3:8b` for suggestions, `nomic-embed-text` for embeddings)

## Knowledge base

Point the app at a folder of Markdown or plain text files. That's it. OpenGranola chunks, embeds, and caches them locally. When the conversation shifts, it searches your notes and only surfaces what's actually relevant.

Works well with meeting prep docs, research notes, pitch decks, competitive analysis, customer briefs — anything you'd want at your fingertips during a call.

## Privacy

- Speech is transcribed locally — audio never leaves your Mac
- **With Ollama**: everything stays on your machine. Zero network calls.
- **With cloud providers**: KB chunks are sent to Voyage AI for embedding (text only, no audio), and conversation context is sent to OpenRouter for suggestions
- API keys are stored in your Mac's Keychain
- The app window is hidden from screen sharing by default
- Transcripts are saved locally to `~/Documents/OpenGranola/`

## Build

```bash
# Full build → sign → install to /Applications
./scripts/build_swift_app.sh

# Dev build only
cd OpenGranola && swift build -c debug

# Package DMG
./scripts/make_dmg.sh
```

Optional env vars for code signing and notarization: `CODESIGN_IDENTITY`, `APPLE_ID`, `APPLE_TEAM_ID`, `APPLE_APP_PASSWORD`.

## Repo layout

```
OpenGranola/          SwiftUI app (Swift Package)
scripts/              Build, sign, and package scripts
assets/               Screenshot and app icon source
```

## License

MIT
