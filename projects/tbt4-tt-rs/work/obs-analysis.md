# OBS Recording Analysis

**Source:** `~/Movies/2026-02-19 13-22-02.mp4`
**Duration:** 2:44 (164 seconds)
**Resolution:** 3024x1862 (Retina, needs scaling to 1920x1080)

## Recording Structure

| Section | Start | End | Duration | Content | Status |
|---------|-------|-----|----------|---------|--------|
| tt1-hover | 0:00 | 0:45 | 45s | tt1-Basic hovertext tour | USE |
| tt2-hover | 0:45 | 1:25 | 40s | tt2-Messaging hovertext tour | USE |
| tt3-hover | 1:25 | 1:40 | 15s | tt3-Sensors hovertext tour | USE |
| tutorial-fillbox | 1:40 | 2:05 | 25s | Fill a Box tutorial | USE |
| tutorial-addnums | 2:05 | 2:30 | 25s | Add Numbers tutorial | USE |
| tutorial-copywand | 2:30 | 2:44 | 14s | Copy with Wand tutorial | **SKIP - ERROR** |

**Total usable:** 0:00 to 2:30 (~150 seconds)

## Frame Reference

| Frame | Time | Content |
|-------|------|---------|
| 001 | 0:01 | tt1-Basic mode, Workspace Notes visible |
| 010 | 0:10 | tt1-Basic mode, overview |
| 020 | 0:20 | tt1-Basic, Magic Wand tooltip |
| 030 | 0:30 | tt1-Basic mode |
| 040 | 0:40 | tt1-Basic, Modulo Tool tooltip |
| 050 | 0:50 | tt2-Messaging, Nest tooltip |
| 060 | 1:00 | tt2-Messaging mode |
| 070 | 1:10 | tt2-Messaging, Magnifier tooltip |
| 080 | 1:20 | tt2-Messaging overview |
| 090 | 1:30 | tt3-Sensors, Random Sensor tooltip |
| 100 | 1:40 | Fill a Box tutorial started |
| 110 | 1:50 | Fill a Box example completed |
| 120 | 2:00 | Fill a Box both sections completed |
| 130 | 2:10 | Add Numbers tutorial started |
| 140 | 2:20 | Add Numbers with dropdown menu |
| 150 | 2:30 | Copy with Wand - attempting example |
| 155 | 2:35 | Copy with Wand - ERROR (red X, "Try again!") |
| 160 | 2:40 | Copy with Wand - error persists |
| 164 | 2:44 | Copy with Wand - end of recording, still error |

## Segment Plan

Given the video structure in README.md and the available OBS footage:

### Planned Segments (Matching README)

| # | Segment | Source | Notes |
|---|---------|--------|-------|
| 05d | fill-the-box-demo | OBS 1:40-2:05 | Extract 25s, scale, add narration |
| 06d | add-numbers-demo | OBS 2:05-2:30 | Extract 25s, scale, add narration |
| 07d | copy-widgets-demo | RE-RECORD | Original has error at frame 150+ |
| 08d | train-robot-demo | NOT IN RECORDING | Need separate OBS session |
| 09d | messaging-demo | NOT IN RECORDING | Need separate OBS session |
| 10d | robot-sensors-demo | NOT IN RECORDING | Need separate OBS session |

### Hovertext Tour Segments (Bonus Content)

The recording also contains hovertext tours for each level. These could be used as:
- Extended intro content for each level
- Bonus segments showing widget features
- B-roll for narration overlays

| Segment | Source | Duration |
|---------|--------|----------|
| tt1-widgets-tour | OBS 0:00-0:45 | 45s |
| tt2-widgets-tour | OBS 0:45-1:25 | 40s |
| tt3-widgets-tour | OBS 1:25-1:40 | 15s |

## Extraction Commands

```bash
# Set up paths
OBS_SRC="$HOME/Movies/2026-02-19 13-22-02.mp4"
CLIPS_DIR="/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips"

# Extract Fill the Box demo (1:40-2:05, 25s)
ffmpeg -y -ss 100 -i "$OBS_SRC" -t 25 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -crf 18 -an "$CLIPS_DIR/05d-fill-the-box-demo-raw.mp4"

# Extract Add Numbers demo (2:05-2:30, 25s)
ffmpeg -y -ss 125 -i "$OBS_SRC" -t 25 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -crf 18 -an "$CLIPS_DIR/06d-add-numbers-demo-raw.mp4"

# Extract hovertext tours
ffmpeg -y -ss 0 -i "$OBS_SRC" -t 45 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -crf 18 -an "$CLIPS_DIR/tt1-hover-raw.mp4"

ffmpeg -y -ss 45 -i "$OBS_SRC" -t 40 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -crf 18 -an "$CLIPS_DIR/tt2-hover-raw.mp4"

ffmpeg -y -ss 85 -i "$OBS_SRC" -t 15 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -crf 18 -an "$CLIPS_DIR/tt3-hover-raw.mp4"
```

## Still Needed

1. **Re-record Copy Widgets tutorial** - Current recording has error at frame 150
2. **Record Train a Robot demo** - Not in current OBS session
3. **Record Messaging demo (tt2)** - Not in current OBS session
4. **Record Robot with Sensors demo (tt3)** - Not in current OBS session
5. **Title video/image** - User will provide
6. **Music selection** - User will provide
