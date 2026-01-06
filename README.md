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
|   +-- rlm/                # RLM Explainer project
|       +-- plan.md         # Production plan
|       +-- assets/
|       |   +-- images/     # Project images (title cards, etc.)
|       |   +-- svg/        # Vector graphics for scenes
|       +-- docs/           # Project-specific documentation
|       |   +-- research.txt
|       +-- work/           # Generated files (gitignored except scripts)
|           +-- scripts/    # Narration text files (source)
|           +-- audio/      # TTS audio (.wav) - generated
|           +-- clips/      # Scene video clips - generated
|           +-- stills/     # PNG frames - generated
+-- crates/                 # Rust library crates
+-- explainer_web/          # Yew/WASM deterministic renderer
+-- script/                 # Scene definitions (future: per-project)
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

## Current Project: RLM Explainer

Location: `projects/rlm/`

Subject: Recursive Language Models (../rlm-project)

Duration: ~3:30 (27 narrated segments + title + epilog)

Structure:
- 01-title: Title card with music (rlm.jpg)
- 02-25: Content segments with Ken Burns effect
- 26-outro: CTA slide with music padding
- 99b-epilog: Standard closing + 5s extension

See `projects/rlm/plan.md` for full production details.

## References

- Video Pipeline Guide: `../video-publishing/reference/docs/video-pipeline-guide.md`
- Voice Reference: `../video-publishing/reference/voice/mike-medium-ref-1.wav`
- Epilog: `../video-publishing/reference/epilog/99b-epilog.mp4`
