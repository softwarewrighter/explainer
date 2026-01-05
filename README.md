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
+-- plan.md              # Production plan
+-- script/
|   +-- scenes.yaml      # Scene definitions
+-- work/
|   +-- scripts/         # Narration text files
|   +-- audio/           # TTS audio (.wav)
|   +-- clips/           # Scene video clips
|   +-- avatar/
|   |   +-- stretched/   # Time-stretched avatars
|   |   +-- lipsynced/   # Lip-synced avatars
|   +-- composited/      # Final segments
+-- assets/
|   +-- svg/             # Vector graphics
+-- out/
    +-- frames/          # Playwright captures
    +-- final.mp4        # Final video
```

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

See `docs/tools.md` for detailed usage.

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

## Current Video: RLM Explainer

Subject: Recursive Language Models (../rlm-project)

Duration: ~90 seconds

Scenes:
- 00-title: Title card with music
- 01-09: Content segments with avatar narration
- 99-epilog: Standard closing

See `plan.md` for full production details.

## References

- Video Pipeline Guide: `../video-publishing/reference/docs/video-pipeline-guide.md`
- Voice Reference: `../video-publishing/reference/voice/mike-medium-ref-1.wav`
- Epilog: `../video-publishing/reference/epilog/99b-epilog.mp4`
