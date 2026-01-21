# Favicon CLI Video - Part 1 Production Plan

An explainer video documenting AI-driven bug discovery in a Rust CLI tool.

> **Reference**: See [Video Pipeline Guide](../../docs/tools.md) for tool documentation.
> **Model**: Based on [babyai-hrm](../babyai-hrm/plan.md) project structure.

---

## Project Info

| Field | Value |
|-------|-------|
| **Project** | favicon |
| **Video Title** | Vibe Coding: AI Agent Finds 5 Bugs in My Favicon Tool |
| **Subject Repo** | favicon CLI |
| **Target Duration** | ~11 minutes |
| **Target Audience** | Developers interested in AI-assisted testing |
| **Format** | OBS screen recording + voiceover narration |
| **Music** | soaring.mp3 (title + epilog bookends) |

---

## Video Structure

This video differs from babyai-hrm in that it uses **OBS screen recording** for the main content, not SVG slides.

### Clip Structure

```
00-title.mp4      - Title sequence (heart image + title SVG, 7s with music)
02-hook-composited.mp4  - Avatar slide with narration (~15s)
03-67-obs-narrated.mp4  - OBS recording with 65 narration clips overlaid (~10 min)
68-cta-composited.mp4   - Avatar slide with narration (~10s)
99-epilog.mp4     - Reference epilog with music extension
```

### Key Differences from babyai-hrm

| Aspect | babyai-hrm | favicon |
|--------|-----------|---------|
| Main content | SVG slides | OBS recording |
| Narration count | ~28 clips | 67 clips |
| Narration method | One audio per slide | Multiple audio overlaid on single video |
| Avatar | center-polo (reference) | curmudgeon.mp4 (custom) |
| Music | pulsar.mp3 | soaring.mp3 |

---

## Source Files

### OBS Recording
```
/Users/mike/Movies/2026-01-07 22-22-53.mp4  (630s / 10.5 min)
```

### Narration Scripts
```
work/scripts/02-hook.txt          - Hook narration
work/scripts/03-setup1.txt        - First OBS narration
...
work/scripts/67-final5.txt        - Last OBS narration
work/scripts/68-cta.txt           - CTA narration
work/scripts/narration-all.txt    - Combined with timestamps
```

### Audio Files
```
work/audio/02-hook.wav            - Hook audio (~15s)
work/audio/03-setup1.wav          - First OBS audio
...
work/audio/67-final5.wav          - Last OBS audio
work/audio/68-cta.wav             - CTA audio (~10s)
```
Total narration: ~604 seconds (~10 minutes)

### SVG Slides (avatar clips only)
```
assets/svg/00-title.svg           - Title card
assets/svg/02-hook.svg            - Hook background
assets/svg/68-cta.svg             - CTA background
```

---

## Production Pipeline

### Step 1: Generate TTS Audio (DONE)
```bash
./scripts/generate-tts.sh  # Already completed, 67 audio files exist
```

### Step 2: Build Title Clip
```bash
# Create title clip: heart image (2s) + title SVG (5s) with music
./scripts/build-title.sh
```

Output: `work/clips/00-title.mp4` (7s with soaring.mp3)

### Step 3: Build Avatar Clips (Hook + CTA)
```bash
# Avatar clips use: SVG -> PNG -> base clip WITH audio -> avatar stretch -> lipsync -> composite
./scripts/build-avatar-clip.sh 02-hook
./scripts/build-avatar-clip.sh 68-cta
```

**CRITICAL**: Base clip must include `--audio` parameter in vid-image call.

Output:
- `work/clips/02-hook-composited.mp4` (~15s with narration)
- `work/clips/68-cta-composited.mp4` (~10s with narration)

### Step 4: Build OBS Narrated Clip
```bash
# Overlay 65 narration clips onto OBS recording at specific timestamps
./scripts/build-obs-narrated.sh
```

This script must:
1. Take OBS recording from ~/Movies
2. Strip original audio
3. Position narration audio at timestamps from narration-all.txt
4. Output narrated OBS clip

Output: `work/clips/03-67-obs-narrated.mp4` (~10 min)

### Step 5: Build Epilog
```bash
# Use reference epilog + add 5s extension with music
./scripts/build-epilog.sh
```

Output: `work/clips/99-epilog.mp4` (~18s total)

### Step 6: Concatenate Final Video
```bash
./scripts/concat-draft.sh
```

Concat list order:
```
00-title.mp4
02-hook-composited.mp4
03-67-obs-narrated.mp4
68-cta-composited.mp4
99-epilog.mp4
```

Output: `work/draft-favicon.mp4` (~11 min)

---

## Timestamps (from narration-all.txt)

The timestamps indicate position in the **final video**, not the OBS recording:

| Timestamp | Segment | Description |
|-----------|---------|-------------|
| 00:00 | 00-title | Title card with music |
| ~00:07 | 02-hook | Avatar hook slide |
| 00:15 | 03-setup1 | First OBS narration |
| ... | ... | 65 narration segments |
| ~10:55 | 67-final5 | Last OBS narration |
| ~11:00 | 68-cta | Avatar CTA slide |
| ~11:15 | 99-epilog | Epilog with music |

Since title (7s) + hook (~15s) = ~22s, the OBS narration timestamps need adjustment:
- Narration timestamp 00:15 maps to OBS position 0:00
- Offset = 15 seconds (to account for hook)

---

## Tool Locations

```bash
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/favicon"
MUSIC="$REFDIR/music/soaring.mp3"
AVATAR_SOURCE="$PROJECT/assets/videos/curmudgeon.mp4"
```

---

## Notes

### Avatar Clip Pattern (from babyai-hrm)

The correct pattern for avatar clips with audio:

```bash
# Step 1: SVG to PNG
rsvg-convert -w 1920 -h 1080 "$SVG" -o "$PNG"

# Step 2: Create base clip WITH AUDIO (critical!)
$VID_IMAGE --image "$PNG" --output "$BASE_CLIP" --audio "$AUDIO_FILE" --effect ken-burns

# Step 3: Stretch avatar
$VID_AVATAR --avatar "$AVATAR_SOURCE" --duration "$DURATION" --output "$STRETCHED"

# Step 4: Lip-sync
$VID_LIPSYNC --avatar "$STRETCHED" --audio "$AUDIO_FILE" --output "$LIPSYNCED"

# Step 5: Composite (uses audio from base clip)
$VID_COMPOSITE --content "$BASE_CLIP" --avatar "$LIPSYNCED" --output "$OUTPUT"
```

### OBS Narration Overlay

This requires positioning multiple audio tracks at specific timestamps on a silent video.
FFmpeg filter: `adelay` for each audio track, then `amix` to combine.

Example (conceptual):
```bash
ffmpeg -i obs.mp4 -i audio1.wav -i audio2.wav ... \
  -filter_complex "[1:a]adelay=15000|15000[a1]; [2:a]adelay=25000|25000[a2]; ... [a1][a2]...amix=inputs=65[aout]" \
  -map 0:v -map "[aout]" output.mp4
```

---

## Bugs Found in Video

1. Named colors (like "red") not supported
2. "transparent" rejected as background color
3. PNG output filename mismatch
4. Animation speed too slow
5. Wrench emoji renders as text (not symbol)
6. Documentation gap: emoji font pre-installation requirements
