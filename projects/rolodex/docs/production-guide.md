# Rolodex Video Production Guide

This document describes the video production workflow for the rolodex explainer video.

## Project Overview

**Topic**: 3D Contact Manager built with Rust, Yew, and Three.js
**Duration Target**: ~3 minutes
**Music**: The Throne - Silent Partner
**Avatar**: curmudgeon.mp4

## Final Output

```bash
# Build final concatenated video
./scripts/build-final.sh

# Output: work/final-rolodex.mp4
# Duration: ~2:42 (162s)
# Format: 1920x1080, 44100 Hz stereo
```

## Directory Structure

```
projects/rolodex/
+-- assets/
|   +-- images/          # Source images (title screenshot)
|   +-- svg/             # Slide SVG files (03-repo-intro.svg, 05-demo-intro.svg)
|   +-- videos/          # Avatar source (curmudgeon.mp4)
+-- docs/
|   +-- production-guide.md  # This file
|   +-- build-lessons.md     # Lessons learned
+-- scripts/
|   +-- common.sh        # Project-specific paths and tool aliases
|   +-- build-all.sh     # Master build script
|   +-- generate-tts.sh  # TTS audio generation
|   +-- build-slide.sh   # SVG + audio -> video clip
|   +-- build-avatar-clip.sh  # Avatar lip-sync workflow
|   +-- build-title.sh   # Title clip with music
|   +-- build-epilog.sh  # Epilog extension clip
|   +-- build-final.sh   # Normalize and concatenate all clips
|   +-- boost-volume.sh  # Audio level adjustment
|   +-- check-levels.sh  # Audio level verification
|   +-- concat-draft.sh  # Quick concatenate (without normalization)
|   +-- normalize-volume.sh  # Volume normalization
+-- work/
    +-- audio/           # TTS audio files
    +-- avatar/          # Stretched and lip-synced avatars
    +-- clips/           # Final video clips
    +-- scripts/         # Narration text files
    +-- stills/          # PNG frames from SVGs
    +-- preview/         # HTML preview with symlinks
    +-- final-rolodex.mp4  # Final concatenated output
```

## Clip Inventory

| Clip | Duration | Type | Description |
|------|----------|------|-------------|
| 00-title.mp4 | 5.0s | Title | Screenshot + Ken Burns + music |
| 02-hook-composited.mp4 | 14.2s | Avatar | Hook with lip-synced avatar |
| 03-repo-intro.mp4 | 10.8s | Slide | Repository intro |
| 04-obs-repo.mp4 | 11.2s | OBS | GitHub repo walkthrough |
| 05-demo-intro.mp4 | 8.0s | Slide | Demo intro |
| 06-obs-demo.mp4 | 12.8s | OBS | Live demo interaction |
| 07-git-clone.mp4 | 9.3s | OBS | Git clone and IDE open |
| 08a-readme.mp4 | 14.9s | Slowed | README.md walkthrough |
| 08b-cargo.mp4 | 15.7s | Slowed | Cargo.toml dependencies |
| 08c-threejs.mp4 | 9.5s | Slowed | three_js.rs module |
| 08d-card.mp4 | 11.0s | Slowed | Card struct definition |
| 08e-testdata.mp4 | 11.3s | Slowed | Test data generation |
| 68-cta-composited.mp4 | 11.0s | Avatar | CTA with lip-synced avatar |
| 99-epilog-final.mp4 | 17.9s | Epilog | Like & Subscribe + music |

**Total**: ~162s (~2:42)

## Production Pipeline

### Step 1: Prepare Scripts

Create narration text files in `work/scripts/`:
- Max 200 characters per file
- Max 2 sentences per file
- Only periods and commas (no colons, exclamation marks, etc.)
- Avoid ALL-CAPS words
- Spell out acronyms: "Three dot j s" not "Three.js", "A P I" not "API"

### Step 2: Generate TTS Audio

```bash
./scripts/generate-tts.sh 02-hook
./scripts/generate-tts.sh 68-cta
```

Or generate all at once:
```bash
./scripts/build-all.sh tts
```

### Step 3: Build Avatar Clips (Parallel)

**CRITICAL**: Run avatar builds on DIFFERENT hive servers to avoid CUDA OOM errors:

```bash
# Terminal 1 - hook on hive:3015
./scripts/build-avatar-clip.sh 02-hook hive:3015

# Terminal 2 - CTA on hive:3016
./scripts/build-avatar-clip.sh 68-cta hive:3016
```

**Never run two MuseTalk jobs on the same server simultaneously!**

### Step 4: Build Slide Clips

```bash
./scripts/build-slide.sh 03-repo-intro
./scripts/build-slide.sh 05-demo-intro
```

### Step 5: Mix Audio into OBS Clips

OBS clips are extracted without narration audio. Mix the TTS audio in:

```bash
ffmpeg -y -i clips/04-obs-repo.mp4 -i audio/04-obs-repo.wav \
    -c:v copy -c:a aac -b:a 192k \
    -map 0:v:0 -map 1:a:0 -shortest \
    clips/04-obs-repo-mixed.mp4 && mv clips/04-obs-repo-mixed.mp4 clips/04-obs-repo.mp4
```

### Step 6: Build Title and Epilog

```bash
./scripts/build-title.sh
./scripts/build-epilog.sh
```

### Step 7: Build Final Video

```bash
./scripts/build-final.sh
```

This script:
1. Normalizes all clips to 44100 Hz stereo
2. Scales any mis-sized clips to 1920x1080
3. Concatenates with vid-concat --reencode
4. Verifies audio format and levels

## Critical Lessons Learned

### 1. Audio Format Normalization - MANDATORY

All clips MUST be 44100 Hz stereo before concat. Mixed formats cause silent audio.

**Verify before concat**:
```bash
for f in *.mp4; do
    echo -n "$f: "
    ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate,channels -of csv=p=0 "$f"
done
# ALL must show: 44100,2
```

**Normalize manually**:
```bash
ffmpeg -y -i input.mp4 -c:v copy -c:a aac -ar 44100 -ac 2 output.mp4
```

### 2. Video Resolution - Must Match

All clips must be 1920x1080. OBS clips may have different resolution.

**Check resolution**:
```bash
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 clip.mp4
```

**Scale to 1920x1080**:
```bash
ffmpeg -y -i input.mp4 \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
    -c:v libx264 -preset fast -crf 18 -c:a copy output.mp4
```

### 3. Slowed Code Clips

To slow video to match narration:
```bash
# Get durations
AUDIO_DUR=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 audio.wav)
TARGET_DUR=$(echo "$AUDIO_DUR + 1" | bc)  # +1s padding
RAW_DUR=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 raw.mp4)
SLOW=$(echo "$TARGET_DUR / $RAW_DUR" | bc -l)

# Slow video
ffmpeg -y -i raw.mp4 -filter:v "setpts=${SLOW}*PTS" -c:v libx264 -an slowed.mp4

# Add audio
ffmpeg -y -i slowed.mp4 -i audio.wav -c:v copy -c:a aac -map 0:v -map 1:a -shortest final.mp4
```

## Tool Reference

All tools are in `$TOOLS` (video-publishing/tools/target/release):

| Tool | Purpose | Key Flags |
|------|---------|-----------|
| vid-tts | Generate TTS audio | --script, --output, --print-duration |
| vid-image | Image to video | --image, --audio, --duration, --effect |
| vid-avatar | Stretch avatar | --avatar, --duration, --fps, --output |
| vid-lipsync | Lip-sync | --avatar, --audio, --server, --output |
| vid-composite | Overlay avatar | --content, --avatar, --output |
| vid-concat | Join clips | --list, --output, --reencode |
| vid-volume | Audio levels | --input, --db, --print-levels |
| vid-scale | Resize video | --width, --height, --pad |

## Troubleshooting

### Audio Disappears After Concat

1. Check all clips are 44100 Hz stereo
2. Use `build-final.sh` which normalizes automatically
3. Use `--reencode` flag with vid-concat

### Resolution Mismatch Error

```
Error: "Input link parameters do not match output link parameters"
```

Scale the problematic clip to 1920x1080 (see above).

### CUDA Out of Memory

Never run two MuseTalk jobs on the same hive server. Use different ports:
- hive:3015
- hive:3016
