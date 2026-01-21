# Explainer - Deterministic Video Rendering Pipeline

A Rust/WASM pipeline for creating explainer videos without OBS screen capture.

## Overview

This project renders animated explainer videos by:
1. Defining scenes in `script/scenes.yaml`
2. Rendering frames deterministically with Yew/WASM + Playwright
3. Generating TTS audio with voice cloning
4. Creating lip-synced avatar overlays
5. Compositing and concatenating to final video

## Prerequisites

- Rust stable + wasm target: `rustup target add wasm32-unknown-unknown`
- Trunk: `cargo install trunk`
- Node.js 18+ with Playwright
- just (command runner)
- Access to video-publishing tools: `../video-publishing/tools/target/release/`

## Quick Start

```bash
# 1. Build the web renderer
just web-build

# 2. Capture frames (headless Chromium)
just frames

# 3. Generate TTS audio
just tts-all

# 4. Process segments (avatar + lipsync + composite)
just process-segment 01-problem 8.5

# 5. Concatenate final video
just concat
```

## Project Structure

```
explainer/
+-- docs/                   # General documentation (tools, workflows)
|   +-- tools.md            # Video pipeline tool documentation
|   +-- process.md          # Development process
+-- projects/               # Individual explainer video projects
|   +-- emacs-mcp/          # Emacs MCP Server Explainer (~4:41)
|   +-- rag/                # RAG Explainer (~3:50)
|   +-- rlm/                # RLM Explainer (~3:30)
+-- crates/                 # Rust library crates
+-- explainer_web/          # Yew/WASM deterministic renderer
+-- script/                 # Scene definitions (future: per-project)
```

See individual project sections below for detailed file trees.

## Scene Types

Scenes are defined in `script/scenes.yaml`:

### SLIDE + Music (Title/Transition)
```yaml
- id: title
  dur_s: 6
  type: slide
  audio: music
  layers:
    - type: text
      text: "Recursive Language Models"
      at: [0.5, 0.4]
      style: { size: 84, weight: 800 }
```

### CONTENT + Avatar (Narrated)
```yaml
- id: problem
  dur_s: 12
  type: content
  audio: avatar
  script: work/scripts/01-problem.txt
  layers:
    - type: svg
      asset: "assets/svg/jar.svg"
      at: [0.5, 0.55]
    - type: text
      text: "Context Windows Are Limited"
      at: [0.5, 0.12]
```

## Video Pipeline Tools

This project uses Rust CLI tools from `../video-publishing/tools/`:

| Tool | Purpose |
|------|---------|
| vid-tts | Generate TTS audio with voice cloning |
| vid-avatar | Stretch avatar to match audio duration |
| vid-lipsync | Generate lip-synced avatar |
| vid-composite | Overlay avatar on content |
| vid-concat | Concatenate segments |
| vid-review | Preview composited segments |
| whisper-cli | Verify TTS transcription accuracy |

See `docs/tools.md` for detailed usage.

### Audio Verification

Verify TTS output with whisper transcription before final assembly:

```bash
# Extract audio and transcribe
ffmpeg -y -i clip.mp4 -ar 16000 -ac 1 -c:a pcm_s16le /tmp/audio.wav
whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/audio.wav -nt
```

**Models (pre-installed):**
- `~/.whisper-models/ggml-base.en.bin` - Fast (148MB)
- `~/.local/share/whisper-cpp/models/ggml-medium.en.bin` - Accurate (1.5GB)

## TTS Voice Guidelines

VibeVoice works best with:
- Short sentences (avoid long paragraphs)
- Simple punctuation (period, comma only)
- No dashes, colons, semicolons, or question marks
- No exclamation marks

Example:
```
# Good
Large language models have a problem. They can only think about so much text at once.

# Avoid
Large language models have a problem: they can only think about so much text at once!
```

## SVG Design Guidelines

**CRITICAL: All SVG text must be readable on video.**

### Minimum Font Sizes

| Element | Minimum Size |
|---------|--------------|
| All text | **28px** |
| Body/labels | 28-32px |
| Monospace/URLs | 28-32px |
| Subtitles | 36-42px |
| Headlines | 84-96px |

**Never use fonts smaller than 28px in any SVG slide.**

```svg
<!-- Good -->
<text font-size="28">github.com/user/repo</text>
<text font-size="32">Label Text</text>

<!-- Bad - too small, illegible on video -->
<text font-size="22">Label</text>
<text font-size="24">github.com/repo</text>
```

See `docs/svg-design-guidelines.md` for complete guidelines.

## Just Commands

```bash
# Web renderer
just web-build          # Build Yew/WASM renderer
just web-serve          # Serve for development

# Frame capture
just render-plan        # Generate render plan from scenes.yaml
just frames             # Capture frames with Playwright

# Audio
just tts 01-problem     # Generate TTS for one segment
just tts-all            # Generate TTS for all segments

# Avatar processing
just avatar-stretch 01-problem 8.5   # Stretch avatar to duration
just lipsync 01-problem              # Lip-sync avatar to audio

# Compositing
just composite 01-problem            # Composite avatar onto content
just add-music 00-title 6.0          # Add music to title slide

# Final assembly
just concat             # Concatenate all segments
just review             # Preview in browser
```

## Projects

### Emacs MCP Server Explainer (Latest)

Location: `projects/emacs-mcp/`

Subject: Rust-based MCP server for Emacs (../emacs-ai-api)

Duration: ~4:41 (33 narrated segments + title + epilog)

```
projects/emacs-mcp/
+-- plan.md                 # Production plan
+-- assets/
|   +-- images/
|   |   +-- emacs-mcp.jpg   # Title card
|   |   +-- gray-beard-android.jpg
|   +-- svg/                # 33 scene graphics
|   +-- videos/
|       +-- gray-beard-android.mp4  # Avatar for lipsync
+-- docs/                   # Project documentation
+-- work/
    +-- scripts/            # 33 narration scripts
    +-- audio/              # TTS audio files
    +-- stills/             # PNG renders
    +-- clips/              # Video clips (36 total)
    +-- description.txt     # YouTube description
    +-- emacs-mcp-draft.mp4
```

Topics covered:
- What Emacs is: extensible text editor, server mode, emacsclient
- What MCP (Model Context Protocol) is: Anthropic's open standard for AI tools
- MCP adoption: OpenAI, Microsoft, and industry-wide support
- MCP concerns: security and complexity considerations
- Implementation: Five tools (dired, open-file, insert, split-window, eval)
- Demo: Eliza chatbot interaction via eval tool
- Bidirectional: gptel lets Emacs call out to LLMs
- Use cases: Code review, pair programming, documentation generation

Features:
- Lip-synced avatar overlay on hook and CTA slides
- gptel segment showing bidirectional LLM integration

Music: missed-chance.mp3 (title and epilog extension)

See `projects/emacs-mcp/plan.md` for full production details.

### RAG Explainer

Location: `projects/rag/`

Subject: Retrieval-Augmented Generation (../rag-demo)

Duration: ~3:50 (32 narrated segments + title + epilog)

```
projects/rag/
+-- plan.md                 # Production plan
+-- assets/
|   +-- images/             # Title card (rag-explainer.jpg)
|   +-- svg/                # 33 scene graphics
+-- docs/                   # Project documentation
+-- work/
    +-- scripts/            # 32 narration scripts
    +-- audio/              # TTS audio files
    +-- stills/             # PNG renders
    +-- clips/              # Video clips
    +-- rag-explainer-draft.mp4
```

Topics covered:
- LLM hallucination problem and knowledge cutoffs
- RAG solution: Retrieve, Augment, Generate
- Vector databases: Qdrant, Pinecone, Weaviate, pgvector
- Hierarchical parent-child chunking (8.2% accuracy improvement)
- Local implementation with Qdrant + Ollama

Music: soaring.mp3 (title and epilog extension)

See `projects/rag/plan.md` for full production details.

### RLM Explainer

Location: `projects/rlm/`

Subject: Recursive Language Models (../rlm-project)

Duration: ~3:30 (27 narrated segments + title + epilog)

```
projects/rlm/
+-- plan.md                 # Production plan
+-- assets/
|   +-- images/             # Title card (rlm.jpg)
|   +-- svg/                # 27 scene graphics
+-- docs/                   # Project documentation
+-- work/
    +-- scripts/            # 27 narration scripts
    +-- audio/              # TTS audio files
    +-- stills/             # PNG renders
    +-- clips/              # Video clips
    +-- avatar/             # Avatar processing
    +-- composited/         # Composited clips
    +-- rlm-draft.mp4
```

Structure:
- 01-title: Title card with music (rlm.jpg)
- 02-25: Content segments with Ken Burns effect
- 26-outro: CTA slide with music padding
- 99b-epilog: Standard closing + 5s extension

See `projects/rlm/plan.md` for full production details.

### RLM CLI Explainer (In Progress)

Location: `projects/rlm-cli/`

Subject: RLM Level 3 Native CLI Execution (../rlm-project)

Duration: ~3:00 so far (visualizer demo pending)

```
projects/rlm-cli/
+-- docs/
|   +-- project-brief.md    # Project overview and lessons
|   +-- plan.md             # Production plan
+-- assets/
|   +-- images/             # Title card (rlm-rust-cli.jpg)
|   +-- svg/                # Hook, intro, percentiles, CTA slides
+-- scripts/                # Build scripts (common.sh, build-avatar-clip.sh, etc.)
+-- work/
    +-- scripts/            # Narration scripts
    +-- audio/              # TTS audio files
    +-- clips/              # Video clips
    +-- avatar/             # Avatar processing
    +-- vhs/                # VHS terminal recordings
    +-- preview/            # Preview HTML page
```

**Completed segments:**
- Title, hook (lipsynced avatar), L3 intro
- Error ranking demo (VHS recording, 3 narrated clips)
- Percentiles demo (VHS recording, 3 narrated clips)
- CTA (lipsynced avatar with GitHub link)
- Epilog + music outro

**Pending:**
- Visualizer intro SVG
- Visualizer OBS recording
- L1 vs L2 vs L3 comparison

See `projects/rlm-cli/docs/project-brief.md` for details.

## Critical Guidelines

### Video Concatenation

**NEVER use raw ffmpeg for concatenation.** Always use `vid-concat`:

```bash
# Concat list: absolute paths, one per line, NO "file '...'" prefix
$VID_CONCAT --list clips/concat-list.txt --output preview.mp4 --reencode
```

**Audio Format:** All clips MUST be 44100Hz stereo. Run `normalize-volume.sh` on every clip:

```bash
./scripts/normalize-volume.sh work/clips/clip.mp4
```

Mixed audio formats (24000Hz mono vs 44100Hz stereo) cause silent or garbled audio in the final video.

## References

- Video Pipeline Guide: `../video-publishing/reference/docs/video-pipeline-guide.md`
- Voice Reference: `../video-publishing/reference/voice/mike-medium-ref-1.wav`
- Epilog: `../video-publishing/reference/epilog/99b-epilog.mp4`
