# RLM WASM Video Pipeline

This document describes the video production pipeline for the RLM WASM explainer video.

## Architecture

The pipeline follows the standard explainer project pattern:

```
User/AI Agent
     |
     v
Master Build Script (build-all-clips.sh)
     |
     v
Step Scripts (build-svg-clip.sh, build-avatar-clip.sh, etc.)
     |
     v
Rust CLI Tools (vid-tts, vid-image, vid-avatar, vid-lipsync, etc.)
     |
     v
ffmpeg (NEVER called directly)
```

## Video Structure

The final video consists of these segments in order:

| Segment | File | Source | Duration |
|---------|------|--------|----------|
| 00 | 00-title.mp4 | Image + music | 5s |
| 01 | 01-hook-composited.mp4 | Avatar + narration | ~18s |
| 03 | 03-l1-dsl.mp4 | SVG + narration | ~17s |
| 04 | 04-l2-wasm.mp4 | SVG + narration | ~20s |
| 05 | l2-error-ranking-narrated.mp4 | VHS + narration | ~50s |
| 06 | l2-percentiles-narrated.mp4 | VHS + narration | ~46s |
| 07 | l2-unique-ips-narrated.mp4 | VHS + narration | ~38s |
| 08 | 08-limitations.mp4 | SVG + narration | ~17s |
| 09 | 09-future.mp4 | SVG + narration | ~15s |
| 14 | 14-cta-composited.mp4 | Avatar + narration | ~15s |
| 99b | 99b-epilog.mp4 | Reference | ~13s |
| 99c | 99c-epilog-ext.mp4 | Music fade | 5s |

## Scripts

### common.sh

Defines paths and tool locations:

```bash
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_CONCAT="$TOOLS/vid-concat"
# ... etc
```

### generate-tts.sh

Generates TTS audio from script files.

```bash
# SVG narration
./scripts/generate-tts.sh l1-overview

# VHS demo narration
./scripts/generate-tts.sh 01-problem error-ranking
```

### generate-all-tts.sh

Batch generates all TTS audio files.

```bash
./scripts/generate-all-tts.sh
```

### build-svg-clip.sh

Creates video clip from SVG with narration audio.

```bash
./scripts/build-svg-clip.sh <svg-name> <audio-name> <output-name>

# Examples:
./scripts/build-svg-clip.sh rlm-l1-dsl l1-overview 03-l1-dsl
./scripts/build-svg-clip.sh rlm-limitations limitations 08-limitations
```

Process:
1. Convert SVG to PNG at 1920x1080 using rsvg-convert
2. Get audio duration from wav file
3. Create video with vid-image, duration = audio + 0.5s

### build-avatar-clip.sh

Creates lip-synced avatar clips for hook and CTA.

```bash
./scripts/build-avatar-clip.sh 01-hook
./scripts/build-avatar-clip.sh 14-cta
```

### build-all-clips.sh

Master script that builds all video segments.

```bash
./scripts/build-all-clips.sh
```

### build-final.sh

Normalizes all clips to 44100 Hz stereo and concatenates.

```bash
./scripts/build-final.sh
```

## File Locations

```
projects/rlm-wasm/
+-- assets/
|   +-- svg/           # Source SVG diagrams
|   |   +-- rlm-l1-dsl.svg
|   |   +-- rlm-l2-wasm.svg
|   |   +-- rlm-limitations.svg
|   |   +-- rlm-future.svg
|   +-- images/        # Title card image
+-- scripts/           # Build scripts
+-- work/
    +-- audio/         # Generated TTS audio
    +-- clips/         # Generated video clips
    +-- png/           # Converted SVG to PNG
    +-- scripts/       # Narration text scripts
    +-- vhs/           # VHS terminal recordings
    |   +-- l2-error-ranking.mp4
    |   +-- l2-percentiles.mp4
    |   +-- l2-unique-ips.mp4
    |   +-- error-ranking/
    |   |   +-- scripts/   # 01-problem.txt through 04-how.txt
    |   |   +-- audio/     # Generated TTS for VHS narration
    |   +-- percentiles/
    |   +-- unique-ips/
    +-- preview.html   # Interactive preview
```

## TTS Narration Guidelines

See docs/tts-narration-guidelines.md for rules:

1. Max 240 characters per script
2. Only periods and commas for punctuation
3. Spell acronyms phonetically: RLM -> R L M, WASM -> web assembly
4. Spell numbers: 64 -> sixty four
5. No hyphens: trade-offs -> trade offs
6. No all caps: ASCII -> ask e

Validate with whisper:
```bash
whisper-cli -m ~/.whisper-models/ggml-base.en.bin audio/limitations.wav
```

## Video Format Requirements

All clips must have consistent format before concatenation:

- Resolution: 1920x1080
- Frame rate: 30 fps
- Audio: 44100 Hz, stereo, AAC

The build-final.sh script normalizes audio format automatically.

## Build Process

Full build from scratch:

```bash
cd projects/rlm-wasm

# 1. Generate all TTS audio
./scripts/generate-all-tts.sh

# 2. Build avatar clips (requires MuseTalk server)
./scripts/build-avatar-clip.sh 01-hook
./scripts/build-avatar-clip.sh 14-cta

# 3. Build all other clips
./scripts/build-all-clips.sh

# 4. Concatenate final video
./scripts/build-final.sh
```

## VHS Demo Recordings

Terminal recordings were captured with VHS tool at 22pt font:

```bash
# Tape files in ../rlm-project/demo/
vhs l2-error-ranking.tape
vhs l2-percentiles.tape
vhs l2-unique-ips.tape
```

Each demo has 4 narration segments:
1. 01-problem.txt - What problem is being solved
2. 02-command.txt - How the command is run
3. 03-results.txt - What the output shows
4. 04-how.txt - How it worked technically

### VHS Narration Overlay

The `build-vhs-narration.sh` script overlays narration on VHS recordings:

```bash
./scripts/build-vhs-narration.sh error-ranking
./scripts/build-vhs-narration.sh percentiles
./scripts/build-vhs-narration.sh unique-ips
```

**Variable-speed quarter timing:**
- Each 10s source quarter is speed-adjusted to match narration + 0.5s
- Narration starts 0.25s into each quarter
- Longer narrations = slower video (gives viewer time to read)
- Shorter narrations = faster video (keeps pace engaging)

**Process:**
1. Extract 4 x 10s quarters from source video
2. Speed-adjust each quarter: `target = narration_duration + 0.5s`
3. Concatenate adjusted quarters
4. Overlay narration at calculated timestamps

NOTE: This script uses ffmpeg directly because no Rust CLI exists for multi-track audio overlay at specific timestamps. The script serves as the documented, repeatable process per project guidelines.

## Preview

Open work/preview.html in browser to review all segments with:
- SVG diagrams inline
- Audio players for narration
- Video previews
- Narration script text
