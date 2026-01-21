# New Explainer Video Project Setup Guide

A step-by-step guide for setting up and producing explainer videos based on OBS screen captures.

## Overview

This workflow produces short explainer videos (~2-4 min) with:
- Title clip with music
- Hook slide with avatar (lip-synced)
- Intro slides with narration
- OBS screen capture segments
- CTA slide with avatar (lip-synced)
- Epilog with like/subscribe and music extension

## Step 1: Create Project Directory

```bash
# From explainer repo root
mkdir -p projects/<project-name>/{assets/{images,svg,videos},docs,scripts,work/{audio,avatar,clips,scripts,stills}}
```

Or copy from template:
```bash
cp -r projects/rolodex projects/<project-name>
```

## Step 2: Configure common.sh

Update `scripts/common.sh` with:

```bash
# Music: Choose from reference/music/
MUSIC="$REFDIR/music/The Throne - Silent Partner.mp3"

# Avatar: Copy to assets/videos/ or reference existing
AVATAR_SOURCE="$ASSETS/videos/curmudgeon.mp4"

# OBS source (if applicable)
OBS_SOURCE="/path/to/obs-capture.mp4"
```

**Available music options:**
- `soaring.mp3` - Uplifting, energetic
- `pulsar.mp3` - Tech/electronic
- `missed-chance.mp3` - Contemplative
- `City of the Wolf - The Mini Vandals.mp3` - Cinematic
- `The Throne - Silent Partner.mp3` - Dramatic/powerful

**Available avatars:**
- `curmudgeon.mp4` - Gray-haired presenter
- `lion-actor.mp4` - Animated character
- `gray-beard-android.mp4` - Tech theme

## Step 3: Analyze OBS Video

Extract frames to understand content structure:

```bash
mkdir -p work/stills/analysis
ffmpeg -i "$OBS_SOURCE" -vf "fps=1" work/stills/analysis/frame_%04d.jpg
```

Review frames to identify:
- Section boundaries (repo, demo, features)
- Good cut points (natural pauses, transitions)
- Segment durations (aim for 5-15 seconds each)

## Step 4: Write Narration Scripts

Create text files in `work/scripts/`:

```bash
echo "Your narration text here." > work/scripts/02-hook.txt
```

### VibeVoice TTS Guidelines (CRITICAL)

**DO:**
- Use only periods and commas
- Spell out acronyms: "Three dot j s" not "Three.js"
- Write numbers as words: "three" not "3"
- Expand contractions: "do not" not "don't"
- Max 200 characters, 2 sentences per file

**DON'T:**
- Use semicolons, colons, or question marks
- Use ALL CAPS words
- Use hyphens in technical terms
- Use apostrophes (contractions)

**Example good script:**
```
I vibe coded a three D rolodex contact manager in your browser. It uses Rust, Yew, and Three dot j s.
```

**Example bad script:**
```
I vibe-coded a 3D rolodex contact manager! It uses Rust, Yew, and Three.js - isn't that cool?
```

## Step 5: Generate TTS Audio

```bash
./scripts/generate-tts.sh 02-hook
./scripts/generate-tts.sh 03-intro
# ... etc
```

Or generate all:
```bash
for f in work/scripts/*.txt; do
    name=$(basename "$f" .txt)
    ./scripts/generate-tts.sh "$name"
done
```

## Step 5b: Verify TTS Audio with Whisper

After generating TTS, verify the audio is correct using Whisper transcription:

```bash
# Extract audio from clip
ffmpeg -i work/audio/02-hook.wav -ar 16000 -ac 1 -c:a pcm_s16le /tmp/verify.wav

# Transcribe with Whisper
whisper-cli -m ~/.local/share/whisper-cpp/models/ggml-medium.en.bin \
    -f /tmp/verify.wav --no-prints
```

**Compare transcription to original script.** Look for:
- Wrong words (similar sounding)
- Nonsense/garbled text
- Missing words or phrases
- Mispronounced technical terms

**If transcription has errors:**
1. Rewrite problematic phrases using synonyms
2. Regenerate TTS
3. Re-verify with Whisper

**Common fixes:**
- "Three dot j s" → "three j s" (if "dot" causes issues)
- "web assembly" → "wasm" or vice versa
- Numbers: "twenty five" instead of "two five"

## Step 6: Create SVG Slides

Create 1920x1080 SVGs in `assets/svg/`:
- `02-hook.svg` - Hook visual (avatar will be composited)
- `03-intro.svg` - Section intro
- `68-cta.svg` - Call to action (avatar will be composited)

**SVG Template:**
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1920 1080" width="1920" height="1080">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#0a0a0f"/>
      <stop offset="100%" style="stop-color:#05050a"/>
    </linearGradient>
  </defs>
  <rect width="1920" height="1080" fill="url(#bg)"/>
  <!-- Your content here -->
</svg>
```

## Step 7: Build Clips

### Title Clip
```bash
./scripts/build-title.sh
```

### Slide Clips (without avatar)
```bash
./scripts/build-slide.sh 02-hook
./scripts/build-slide.sh 03-intro
./scripts/build-slide.sh 68-cta
```

### Avatar Clips (with lip-sync)

**CRITICAL: Use DIFFERENT hive servers for parallel builds to avoid GPU OOM errors!**

The MuseTalk lip-sync requires significant GPU memory. Running two jobs on the same server will cause CUDA out-of-memory errors.

```bash
# Terminal 1 - Hook on hive:3015
./scripts/build-avatar-clip.sh 02-hook hive:3015

# Terminal 2 (SEPARATE!) - CTA on hive:3016
./scripts/build-avatar-clip.sh 68-cta hive:3016
```

The second argument specifies the MuseTalk server. Available servers:
- `hive:3015` - Primary MuseTalk instance
- `hive:3016` - Secondary MuseTalk instance

**IMPORTANT:** Do NOT override fps in vid-avatar or vid-lipsync. Use defaults.

### OBS Segments
```bash
# Extract segment from OBS video
ffmpeg -y -ss 0 -i "$OBS_SOURCE" -t 15 \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
    -c:v libx264 -preset fast -crf 18 \
    -c:a aac -ar 44100 -ac 2 \
    work/clips/04-obs-repo.mp4
```

## Step 8: Build Epilog

```bash
./scripts/build-epilog.sh
```

This creates:
- `99b-epilog.mp4` - Reference epilog (normalized audio)
- `99c-epilog-ext.mp4` - 5s extension with project music
- `99-epilog-final.mp4` - Combined final

## Step 9: Create Preview HTML

Create preview directory with symlinks to assets:

```bash
mkdir -p work/preview
cd work/preview
ln -sf ../clips clips
ln -sf ../audio audio
```

**IMPORTANT:** The preview HTML cannot use `..` relative paths (they won't work when served via HTTP). Use symlinks instead to reference clips and audio from the preview directory.

Create `work/preview/index.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Project Name - Preview</title>
    <style>
        body { font-family: sans-serif; background: #1a1a1a; color: #fff; margin: 20px; }
        .clip { margin: 20px 0; padding: 15px; background: #2d2d2d; border-radius: 8px; }
        video { width: 640px; border-radius: 4px; }
        .narration { color: #ccc; margin-top: 10px; padding: 10px; background: #1a1a1a; }
    </style>
</head>
<body>
    <h1>Project Name - Preview</h1>

    <div class="clip">
        <h3>00-title</h3>
        <video controls><source src="clips/00-title.mp4" type="video/mp4"></video>
    </div>

    <div class="clip">
        <h3>02-hook</h3>
        <video controls><source src="clips/02-hook.mp4" type="video/mp4"></video>
        <audio controls><source src="audio/02-hook.wav" type="audio/wav"></audio>
    </div>

    <!-- Add more clips... -->

</body>
</html>
```

View preview:
```bash
cd work/preview && python3 -m http.server 8000
# Open http://localhost:8000/
```

## Step 10: Audio Normalization (CRITICAL)

**ALWAYS normalize audio before concatenation:**

```bash
./scripts/normalize-volume.sh work/clips/clip.mp4 -25
```

**Required format:** 44100 Hz stereo AAC

**Verify before concat:**
```bash
for f in work/clips/*.mp4; do
    echo -n "$f: "
    ffprobe -v error -select_streams a:0 \
        -show_entries stream=sample_rate,channels -of csv=p=0 "$f"
done
# All should show: 44100,2
```

## Step 11: Final Concatenation

Create concat list:
```bash
ls work/clips/*.mp4 | sort > work/clips/concat-list.txt
```

Concatenate:
```bash
./scripts/concat-draft.sh
```

## Common Issues

### Audio Lost After Concat
- Cause: Sample rate mismatch (24000 Hz vs 44100 Hz)
- Fix: Run normalize-volume.sh on all clips before concat

### Lip-sync Too Fast
- Cause: Overriding fps in vid-avatar/vid-lipsync
- Fix: Use default fps (30), don't add --fps flag

### Resolution Mismatch
- Cause: OBS video not 1920x1080
- Fix: Scale with ffmpeg pad filter

### SVG Rendering Issues
- Check: `rsvg-convert -w 1920 -h 1080 input.svg -o output.png`
- Install: `brew install librsvg`

## File Naming Convention

| Prefix | Type | Example |
|--------|------|---------|
| 00 | Title | 00-title.mp4 |
| 02 | Hook | 02-hook.mp4 |
| 03-XX | Content | 03-intro.mp4, 04-demo.mp4 |
| 68 | CTA | 68-cta.mp4 |
| 99 | Epilog | 99-epilog-final.mp4 |
| 999 | Preview placeholder | 999-epilog.mp4 |

## Checklist

- [ ] common.sh configured (music, avatar, paths)
- [ ] OBS video analyzed and segmented
- [ ] Narration scripts follow VibeVoice guidelines
- [ ] TTS audio generated for all scripts
- [ ] SVG slides created (1920x1080)
- [ ] All clips normalized to 44100 Hz stereo
- [ ] Preview HTML created and reviewed
- [ ] Audio levels checked (~-25 dB mean)
- [ ] Title and epilog use same music
