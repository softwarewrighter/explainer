# Favicon Video Production Guide

This document describes the video production workflow for the favicon explainer video.

## Project Overview

**Topic**: Favicon generator CLI tool
**Duration Target**: 5-7 minutes
**Music**: soaring.mp3
**Avatar**: lion-actor.mp4 (custom avatar, 24fps source)

## Directory Structure

```
projects/favicon/
+-- assets/
|   +-- images/          # Source images (heart-favicon2.jpg)
|   +-- svg/             # Slide SVG files (02-hook.svg, 29-cta.svg)
|   +-- videos/          # Avatar source (lion-actor.mp4)
+-- docs/
|   +-- production-guide.md  # This file
+-- scripts/
|   +-- common.sh        # Project-specific paths and tool aliases
|   +-- build-all.sh     # Master build script
|   +-- generate-tts.sh  # TTS audio generation
|   +-- build-slide.sh   # SVG + audio -> video clip
|   +-- build-avatar-clip.sh  # Avatar lip-sync workflow
|   +-- build-title.sh   # Title clip with music
|   +-- build-epilog.sh  # Epilog extension clip
|   +-- boost-volume.sh  # Audio level adjustment
|   +-- check-levels.sh  # Audio level verification
|   +-- concat-draft.sh  # Concatenate all clips
+-- work/
    +-- audio/           # TTS audio files
    +-- avatar/          # Stretched and lip-synced avatars
    +-- clips/           # Final video clips
    +-- scripts/         # Narration text files
    +-- stills/          # PNG frames from SVGs
```

## Production Pipeline

### Step 1: Prepare Scripts

Create narration text files in `work/scripts/`:
- Max 200 characters per file
- Max 2 sentences per file
- Only periods and commas (no colons, exclamation marks, etc.)
- Avoid ALL-CAPS words

### Step 2: Generate TTS Audio

```bash
./scripts/generate-tts.sh 02-hook
./scripts/generate-tts.sh 29-cta
```

### Step 3: Build Clips

**Title clip** (image + music):
```bash
./scripts/build-title.sh
```

**Slide clips** (SVG + TTS, no avatar):
```bash
./scripts/build-slide.sh 03-features
```

**Avatar clips** (SVG + TTS + lip-synced avatar):
```bash
./scripts/build-avatar-clip.sh 02-hook
./scripts/build-avatar-clip.sh 29-cta
```

**Epilog** (from reference):
```bash
./scripts/build-epilog.sh
```

### Step 4: Verify Audio Levels

```bash
./scripts/check-levels.sh
```

Target levels:
- Speech/narration: -24 to -28 dB mean
- Background music: -30 to -35 dB mean

### Step 5: Concatenate Draft

```bash
./scripts/concat-draft.sh
```

## Custom Avatar Notes

This project uses `lion-actor.mp4` as the avatar source instead of reference avatars.

Key differences from reference avatars:
- Located in `assets/videos/` not reference directory
- Same technical specs: 960x960, 24fps, 5.04s
- Uses `--avatar` parameter instead of `--facing`

## Tool Reference

All tools are in `$TOOLS` (video-publishing/tools/target/release):

| Tool | Purpose | Key Flags |
|------|---------|-----------|
| vid-tts | Generate TTS audio | --script, --output, --print-duration |
| vid-image | Image to video | --image, --audio, --duration, --effect |
| vid-avatar | Stretch avatar | --avatar, --duration, --fps, --output |
| vid-lipsync | Lip-sync | --avatar, --audio, --fps, --output |
| vid-composite | Overlay avatar | --content, --avatar, --output |
| vid-concat | Join clips | --list, --output, --reencode |
| vid-volume | Audio levels | --input, --db, --print-levels |
| vid-scale | Resize video | --width, --height, --pad |

## Troubleshooting

### Lips Moving Too Fast

If lip-sync output has faster lip movement than audio:
- Check fps mismatch between avatar stretch and lipsync
- Source avatar is 24fps; maintain this through the pipeline
- Use `--fps 24` for both vid-avatar and vid-lipsync

### Audio Too Quiet

If clips have low audio levels:
```bash
./scripts/boost-volume.sh clip-name.mp4 10
```

### Resolution Mismatch in Concat

If vid-concat fails with resolution errors:
```bash
vid-scale --input problem-clip.mp4 --output fixed.mp4 --width 1920 --height 1080 --pad
```
