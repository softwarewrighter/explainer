# RLM Explainer Video - Production Plan

A short explainer video about Recursive Language Models (RLM) using the deterministic render pipeline.

> **Reference**: See [Video Pipeline Guide](../video-publishing/reference/docs/video-pipeline-guide.md) for general pipeline steps and commands.

---

## Project Info

| Field | Value |
|-------|-------|
| **Project** | explainer |
| **Video Title** | Recursive Language Models: Expanding the Workspace |
| **Subject Repo** | ../rlm-project |
| **Target Duration** | ~90 seconds |
| **Format** | Animated explainer (no OBS screen capture) |

---

## The Video: RLM Explainer

### Core Concept

Explain how Recursive Language Models solve the context window limitation using the "cookie jar" analogy:
- Regular LLMs try to dump the whole jar on the table (context overflow)
- RLMs use tools to peek at pieces (structured exploration)
- Result: 91% accuracy on tasks where base models score 0%

### Visual Arc (10 scenes, ~90 seconds)

| Scene | Duration | Visual | Narration Focus |
|-------|----------|--------|-----------------|
| 00-title | 6s | Title card with music | Hook |
| 01-problem | 12s | Cookie jar overflowing | Context window limits |
| 02-context-rot | 8s | Fog degrading jar | Data loss problem |
| 03-solution | 7s | Tools appear | RLM introduction |
| 04-context-box | 8s | Grid of parts | Peek mechanic |
| 05-commands | 10s | JSON commands | Structured ops |
| 06-implementation | 10s | JSON vs WASM | Current + Future |
| 07-analogy | 10s | Library catalog | Intuitive explanation |
| 08-results | 8s | Accuracy gauge | Dramatic improvement |
| 09-conclusion | 6s | Tagline | Key insight |
| 99-epilog | 12.8s | Standard closing | CTA |

---

## Pipeline Workflow

### Rendering Approach

This project uses **Playwright frame capture** of a Yew/WASM renderer:

```
scenes.yaml -> explainer_web (Yew) -> Playwright screenshots -> PNG frames
```

Then standard video pipeline for audio/avatar:

```
scripts/*.txt -> vid-tts -> vid-avatar -> vid-lipsync -> vid-composite
```

### Tool Locations

```bash
# Video pipeline tools
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR="/Users/mike/github/softwarewrighter/explainer/work"
```

---

## Production Steps

### Phase 1: Frame Rendering (Playwright)

```bash
# 1. Build web renderer
just web-build

# 2. Generate render plan
cargo run -p explainerctl -- render-plan

# 3. Capture frames (headless Chromium)
just frames

# Output: out/frames/frame_000000.png ...
```

### Phase 2: Audio Generation

```bash
# For each scene with avatar narration:
$VID_TTS --script work/scripts/01-problem.txt \
  --output work/audio/01-problem.wav \
  --print-duration

# Note the durations for avatar stretching
```

### Phase 3: Avatar Processing

```bash
# For each narrated segment:

# 1. Stretch avatar to match audio
$VID_AVATAR --facing center \
  --duration $DURATION \
  --reference-dir "$REFDIR" \
  --output work/avatar/stretched/01-problem.mp4

# 2. Lip-sync (run SEQUENTIALLY - GPU memory)
$VID_LIPSYNC --avatar work/avatar/stretched/01-problem.mp4 \
  --audio work/audio/01-problem.wav \
  --output work/avatar/lipsynced/01-problem.mp4
```

### Phase 4: Compositing

```bash
# Create video clips from rendered frames for each scene
# Then composite avatar overlay

$VID_COMPOSITE --content work/clips/01-problem.mp4 \
  --avatar work/avatar/lipsynced/01-problem.mp4 \
  --audio work/audio/01-problem.wav \
  --output work/composited/01-problem.mp4
```

### Phase 5: Music for Non-Avatar Segments

```bash
# Title slide with music
MUSIC="$REFDIR/music/swing9.mp3"
DUR=6.0
FADE_OUT=$(echo "$DUR - 2" | bc)

ffmpeg -y -i work/clips/00-title.mp4 -ss 15 -t $DUR -i "$MUSIC" \
  -filter_complex "[1:a]volume=0.3,afade=t=in:st=0:d=1,afade=t=out:st=$FADE_OUT:d=2[aout]" \
  -map 0:v -map "[aout]" -c:v copy -c:a aac -shortest \
  work/composited/00-title.mp4
```

### Phase 6: Final Assembly

```bash
# Create concat list
ls -1 work/composited/*.mp4 | sort > work/composited/concat.txt

# Add epilog
echo "$REFDIR/epilog/99b-epilog.mp4" >> work/composited/concat.txt

# Concatenate
$VID_CONCAT --list work/composited/concat.txt \
  --output out/final.mp4 \
  --reencode
```

---

## Segment Types

### Type: SLIDE + Music (Title)

| Property | Value |
|----------|-------|
| Background | Rendered frames from Playwright |
| Avatar | NO |
| Audio | Background music (30% volume, fades) |
| Use for | 00-title |

### Type: CONTENT + Avatar (Narrated)

| Property | Value |
|----------|-------|
| Background | Rendered frames from Playwright |
| Avatar | YES (lip-synced, center, 240x240) |
| Audio | Voice narration (TTS) |
| Use for | 01-09 scenes |

### Type: Epilog (Shared)

| Property | Value |
|----------|-------|
| Source | ../video-publishing/reference/epilog/99b-epilog.mp4 |
| Duration | 12.8 seconds |
| Use for | 99-epilog |

---

## Production Checklist

### Phase 1: Setup
- [x] Project directory created
- [x] Scenes.yaml designed
- [x] Scripts written (work/scripts/*.txt)
- [x] Work directory structure created
- [ ] SVG assets created (assets/svg/jar.svg, etc.)
- [ ] Web renderer updated for new scene types

### Phase 2: Rendering
- [ ] Web renderer builds successfully
- [ ] Playwright captures frames for all scenes
- [ ] Frame quality verified

### Phase 3: Audio
- [ ] TTS generated for all narrated scenes
- [ ] Audio durations recorded
- [ ] Audio quality verified

### Phase 4: Avatar
- [ ] Avatars stretched to match audio
- [ ] Lip-sync generated (sequential, not parallel)
- [ ] Lip-sync quality verified

### Phase 5: Compositing
- [ ] All scenes composited
- [ ] Music added to title
- [ ] Video reviewed in vid-review

### Phase 6: Final
- [ ] All segments concatenated
- [ ] Epilog appended
- [ ] Final video reviewed
- [ ] YouTube upload ready

---

## File Organization

```
explainer/
+-- plan.md              # This file
+-- script/
|   +-- scenes.yaml      # Scene definitions
+-- work/
|   +-- scripts/         # Narration text files
|   |   +-- 00-title.txt
|   |   +-- 01-problem.txt
|   |   +-- ...
|   +-- audio/           # TTS audio (.wav)
|   +-- stills/          # Extracted frames (if needed)
|   +-- clips/           # Scene video clips
|   +-- avatar/
|   |   +-- stretched/   # Time-stretched avatars
|   |   +-- lipsynced/   # Lip-synced avatars
|   +-- composited/      # Final segments
+-- assets/
|   +-- svg/             # Vector graphics
|       +-- jar.svg
|       +-- jar-with-tools.svg
|       +-- library.svg
+-- out/
    +-- frames/          # Playwright captures
    +-- final.mp4        # Final video
```

---

## Commands Quick Reference

### MANDATORY: Use Rust vid-* Tools Only

```bash
# Variables
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR="/Users/mike/github/softwarewrighter/explainer/work"

# Rust CLI Tools
VID_TTS="$TOOLS/vid-tts"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
VID_REVIEW="$TOOLS/vid-review"
```

### Segment Processing

```bash
# 1. Generate TTS
$VID_TTS --script "$WORKDIR/scripts/01-problem.txt" \
  --output "$WORKDIR/audio/01-problem.wav" \
  --print-duration

# 2. Stretch avatar
$VID_AVATAR --facing center --duration $DUR \
  --reference-dir "$REFDIR" \
  --output "$WORKDIR/avatar/stretched/01-problem.mp4"

# 3. Lip sync
$VID_LIPSYNC --avatar "$WORKDIR/avatar/stretched/01-problem.mp4" \
  --audio "$WORKDIR/audio/01-problem.wav" \
  --output "$WORKDIR/avatar/lipsynced/01-problem.mp4"

# 4. Composite
$VID_COMPOSITE --content "$WORKDIR/clips/01-problem.mp4" \
  --avatar "$WORKDIR/avatar/lipsynced/01-problem.mp4" \
  --audio "$WORKDIR/audio/01-problem.wav" \
  --output "$WORKDIR/composited/01-problem.mp4"
```

---

## YouTube Metadata

### Title
"Recursive Language Models: How AI Handles 10 Million Tokens"

### Description
```
How do you search a 10 million token "cookie jar" without dumping it on the table?

Recursive Language Models (RLM) solve the context window problem by giving AI tools to explore, rather than forcing everything into memory.

Key concepts:
- Context windows are limited (even GPT-5)
- RLM uses structured commands to peek at pieces
- Result: 91% accuracy where base models score 0%

Paper: https://arxiv.org/html/2512.24601v1
Implementation: https://github.com/softwarewrighter/rlm-project

Chapters:
0:00 Introduction
0:06 The Problem
0:18 Context Rot
0:26 The Solution
0:33 Context Box
0:41 Structured Commands
0:51 Implementation
1:01 Library Analogy
1:11 Results
1:19 Conclusion

#AI #LLM #RecursiveLanguageModels #ContextWindow #MachineLearning
```

---

## Notes

- No OBS screen recording needed - all visuals are rendered by Playwright
- Avatar uses center facing (looking at camera) since no screen content
- Music only on title slide; all other segments have avatar narration
- Cookie jar metaphor from docs/rlm-eli5.md in rlm-project
- Voice clone reference: mike-medium-ref-1.wav
