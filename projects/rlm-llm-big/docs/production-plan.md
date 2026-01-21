# RLM Level 4: War and Peace Family Tree - Production Plan

## Quick Reference

| Property | Value |
|----------|-------|
| **VHS FontSize** | 32 |
| **SVG Headlines** | 96px bold |
| **SVG Body** | 44-48px |
| **SVG Strokes** | 6px |
| **TTS Max Chars** | 320 |
| **Clip Duration** | 8-12 seconds each |
| **Audio Format** | 44100Hz stereo |

---

## Phase 1: Capture Full Demo Recording

### Step 1.1: Create VHS Tape File

Create `work/vhs/family-tree-demo-32pt.tape`:

```tape
# VHS Tape: L4 Family Tree Demo
# Records the full family-tree-demo.sh

Output work/vhs/family-tree-demo-32pt.mp4

Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set TypingSpeed 50ms
Set Theme "Dracula"
Set Padding 20

Sleep 500ms

# Export env vars and run demo
Type "export $(cat ~/.env | grep -v '^#' | xargs) && ./demo/l4/family-tree-demo.sh"
Enter

# Wait for demo to complete (~3-5 minutes)
Sleep 300s
```

### Step 1.2: Run VHS Recording

```bash
cd /Users/mike/github/softwarewrighter/rlm-project
vhs ../explainer/projects/rlm-llm-big/work/vhs/family-tree-demo-32pt.tape
```

### Step 1.3: Verify Recording

```bash
ffprobe -v error -show_entries format=duration -of csv=p=0 work/vhs/family-tree-demo-32pt.mp4
```

---

## Phase 2: Extract and Analyze Stills

### Step 2.1: Create Directories

```bash
mkdir -p work/vhs/stills-1s work/vhs/thumbs-1s
```

### Step 2.2: Extract Stills Every 1 Second

```bash
ffmpeg -i work/vhs/family-tree-demo-32pt.mp4 -vf "fps=1" work/vhs/stills-1s/frame_%04d.png
```

### Step 2.3: Create Thumbnails for Analysis

```bash
for f in work/vhs/stills-1s/*.png; do
    name=$(basename "$f")
    sips -Z 1200 "$f" --out "work/vhs/thumbs-1s/$name"
done
```

### Step 2.4: Analyze ALL Stills

Review every frame to identify:
1. **Demo intro/title** - frames showing script header
2. **File stats display** - showing 3.3MB, 65,660 lines
3. **Query display** - showing the family tree query
4. **Phase processing** - 5 phases reducing data
5. **Iteration 1** - rust_cli_intent chosen
6. **Code generation** - Rust code being generated
7. **Iteration 2** - llm_reduce chosen
8. **Chunk processing** - LLM processing chunks
9. **Results** - family trees output
10. **Demo complete** - final summary

Document frame numbers for each segment boundary.

---

## Phase 3: Plan Segment Breakdown

### Expected Segments (8-12 seconds each)

| Segment | Frames | Description | Narration Focus |
|---------|--------|-------------|-----------------|
| 03a-setup | 1-12 | File stats, challenge | "Three megabytes, sixty thousand lines" |
| 03b-query | 13-24 | Query and command | "Build family trees from noble families" |
| 03c-phases | 25-42 | Phased processing | "Five phases reduce data eighty percent" |
| 03d-iter1 | 43-58 | Iteration 1 rust_cli_intent | "Language Model chooses code generation" |
| 03e-code | 59-70 | Rust code generated | "Extracts relationship sentences" |
| 03f-iter2 | 71-86 | Iteration 2 llm_reduce | "Switches to semantic analysis" |
| 03g-chunks | 87-100 | Chunk processing | "Processes filtered data in chunks" |
| 03h-results | 101-120 | Family trees output | "Four noble families identified" |
| 03i-summary | 121-135 | Demo complete | "From three megabytes to structured trees" |

**Note:** Actual frame numbers will be determined after analyzing stills.

---

## Phase 4: Create Intro and Interstitial Slides

### Required SVG Slides

| Slide | Purpose | Content |
|-------|---------|---------|
| 01-hook.svg | Opening hook | "What if your LLM could analyze 3MB?" |
| 02-intro-demo.svg | Demo introduction | File size, challenge, approach |
| 03-sep-phases.svg | Interstitial | "Phased Processing" header |
| 03-sep-iter1.svg | Interstitial | "Iteration 1: Code Generation" |
| 03-sep-iter2.svg | Interstitial | "Iteration 2: LLM Analysis" |
| 03-sep-results.svg | Interstitial | "Results" header |
| 99-cta.svg | Call to action | GitHub link, try it yourself |

### SVG Font Requirements

```
Headlines:     96px bold, #00d4ff
Subtitles:     64px, #ffd93d
Box titles:    48px bold, colored
Box content:   44px, #eee (SAME size for all items)
Strokes:       6px
Avatar zone:   Keep bottom-right 520x280 clear
```

---

## Phase 5: Generate Narration Scripts

### TTS Rules (MANDATORY)

- Max 320 characters
- Only periods and commas
- NO digits - spell out as words
- NO question marks, dashes, colons
- Spell out: LLM → Language Model, RLM → Recursive Language Model

### Example Scripts

**01-hook.txt** (~200 chars):
```
What if your Language Model could analyze a three megabyte novel.
Sixty thousand lines of text, far too large for any context window.
Recursive Language Model makes it possible.
```

**03a-setup.txt** (~180 chars):
```
The input file is War and Peace by Tolstoy.
Over three megabytes of text, sixty thousand lines.
Far too large for any Language Model context window.
```

**03d-iter1.txt** (~200 chars):
```
In iteration one, the Language Model chooses rust command line intent.
It generates Rust code to extract family relationship sentences.
The code compiles and executes in milliseconds.
```

---

## Phase 6: Extract Video Segments

### Step 6.1: Extract Raw Segments

For each segment identified in Phase 3:

```bash
# Example: Extract frames 1-12 (0-12 seconds)
ffmpeg -y -ss 0 -i work/vhs/family-tree-demo-32pt.mp4 -t 12 \
  -c:v libx264 -crf 18 -an \
  work/vhs/clips/03a-setup-raw.mp4
```

### Step 6.2: Generate TTS Audio

```bash
$VID_TTS --script work/scripts/03a-setup.txt --output work/audio/03a-setup.wav
```

### Step 6.3: Get Audio Duration

```bash
ffprobe -v error -show_entries format=duration -of csv=p=0 work/audio/03a-setup.wav
```

### Step 6.4: Adjust Video to Match Audio + 0.5s

```bash
# Calculate: target_duration = audio_duration + 0.5
# Calculate: pts_factor = src_duration / target_duration

ffmpeg -y -i work/vhs/clips/03a-setup-raw.mp4 -i work/audio/03a-setup.wav \
  -filter_complex "[0:v]setpts=PTS_FACTOR*PTS[v]" \
  -map "[v]" -map 1:a \
  -c:v libx264 -crf 18 -c:a aac -b:a 192k \
  -shortest work/clips/03a-setup.mp4
```

### Step 6.5: Normalize Audio

```bash
./scripts/normalize-volume.sh work/clips/03a-setup.mp4
```

---

## Phase 7: Build Avatar Clips (Hook and CTA)

### Step 7.1: Render SVG to PNG

```bash
rsvg-convert -w 1920 -h 1080 assets/svg/01-hook.svg -o work/stills/01-hook.png
```

### Step 7.2: Create Base Clip

```bash
$VID_IMAGE --image work/stills/01-hook.png --audio work/audio/01-hook.wav \
  --output work/clips/01-hook-base.mp4 --ken-burns 1.02
```

### Step 7.3: Stretch Avatar

```bash
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 work/audio/01-hook.wav)
$VID_AVATAR --duration $DURATION --output work/avatar/01-hook-avatar.mp4
```

### Step 7.4: Lipsync (Use BOTH ports for parallel)

```bash
# Split long narrations into 2 parts if > 15 seconds
# Use port 3015 for part 1, port 3016 for part 2

$VID_LIPSYNC --audio work/audio/01-hook.wav \
  --avatar work/avatar/01-hook-avatar.mp4 \
  --output work/avatar/01-hook-lipsync.mp4 \
  --host hive:3015
```

### Step 7.5: Composite

```bash
$VID_COMPOSITE --background work/clips/01-hook-base.mp4 \
  --overlay work/avatar/01-hook-lipsync.mp4 \
  --output work/clips/01-hook-composited.mp4
```

### Step 7.6: Normalize

```bash
./scripts/normalize-volume.sh work/clips/01-hook-composited.mp4
```

---

## Phase 8: Build Title and Epilog

### Title Clip (00-title)

```bash
# Scale title image
ffmpeg -y -i assets/images/rlm-turtle-llms.jpg \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  work/stills/title-scaled.jpg

# Create title clip with music
ffmpeg -y -loop 1 -i work/stills/title-scaled.jpg -i assets/music/take-it-over.mp3 \
  -t 6 \
  -filter_complex "[1:a]afade=t=in:st=0:d=1,afade=t=out:st=4.5:d=1.5,volume=0.4[a]" \
  -map 0:v -map "[a]" \
  -c:v libx264 -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  -shortest work/clips/00-title.mp4
```

### Epilog (99b, 99c)

Copy standard epilog from reference:
```bash
cp ../video-publishing/reference/epilog/99b-epilog.mp4 work/clips/
```

Create epilog extension with project music:
```bash
# Extract last frame from epilog
ffmpeg -y -sseof -1 -i work/clips/99b-epilog.mp4 -vframes 1 work/stills/epilog-frame.png

# Create extension with music fade
ffmpeg -y -loop 1 -i work/stills/epilog-frame.png -i assets/music/take-it-over.mp3 \
  -t 12 \
  -filter_complex "[1:a]afade=t=out:st=7:d=5,volume=0.4[a]" \
  -map 0:v -map "[a]" \
  -c:v libx264 -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  -shortest work/clips/99c-epilog-ext.mp4
```

---

## Phase 9: Create Concat List and Final Video

### Step 9.1: Create Concat List

```
/full/path/work/clips/00-title.mp4
/full/path/work/clips/01-hook-composited.mp4
/full/path/work/clips/02-intro-demo.mp4
/full/path/work/clips/03a-setup.mp4
/full/path/work/clips/03b-query.mp4
/full/path/work/clips/03c-phases.mp4
/full/path/work/clips/03-sep-iter1.mp4
/full/path/work/clips/03d-iter1.mp4
/full/path/work/clips/03e-code.mp4
/full/path/work/clips/03-sep-iter2.mp4
/full/path/work/clips/03f-iter2.mp4
/full/path/work/clips/03g-chunks.mp4
/full/path/work/clips/03-sep-results.mp4
/full/path/work/clips/03h-results.mp4
/full/path/work/clips/03i-summary.mp4
/full/path/work/clips/99-cta-composited.mp4
/full/path/work/clips/99b-epilog.mp4
/full/path/work/clips/99c-epilog-ext.mp4
```

### Step 9.2: Verify All Clips Normalized

```bash
for clip in work/clips/*.mp4; do
    ./scripts/normalize-volume.sh "$clip"
done
```

### Step 9.3: Concatenate

```bash
$VID_CONCAT --list work/clips/concat-list.txt --output work/preview/preview.mp4 --reencode
```

---

## Phase 10: Verification

### Step 10.1: Check Duration

```bash
ffprobe -v error -show_entries format=duration -of csv=p=0 work/preview/preview.mp4
# Expected: ~3:00-4:00
```

### Step 10.2: Whisper Verification

```bash
ffmpeg -y -i work/preview/preview.mp4 -ar 16000 -ac 1 -c:a pcm_s16le /tmp/full-audio.wav
whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/full-audio.wav -nt
```

### Step 10.3: Spot Check Audio Sync

```bash
ffplay -autoexit -ss 30 -t 10 work/preview/preview.mp4   # Check middle
ffplay -autoexit -ss 120 -t 10 work/preview/preview.mp4  # Check near end
```

---

## Video Structure Summary

| # | Segment | Duration | Type | Avatar |
|---|---------|----------|------|--------|
| 00 | Title | 6s | Image + music | No |
| 01 | Hook | ~18s | SVG + narration | Yes |
| 02 | Intro Demo | ~15s | SVG + narration | No |
| 03a | VHS Setup | 10s | VHS + narration | No |
| 03b | VHS Query | 10s | VHS + narration | No |
| 03c | VHS Phases | 12s | VHS + narration | No |
| 03-sep | Iteration 1 | 3s | SVG separator | No |
| 03d | VHS Iter1 | 10s | VHS + narration | No |
| 03e | VHS Code | 10s | VHS + narration | No |
| 03-sep | Iteration 2 | 3s | SVG separator | No |
| 03f | VHS Iter2 | 10s | VHS + narration | No |
| 03g | VHS Chunks | 12s | VHS + narration | No |
| 03-sep | Results | 3s | SVG separator | No |
| 03h | VHS Results | 12s | VHS + narration | No |
| 03i | VHS Summary | 10s | VHS + narration | No |
| 99 | CTA | ~15s | SVG + narration | Yes |
| 99b | Epilog | ~11s | Standard + narration | Yes |
| 99c | Epilog Ext | 12s | Image + music | No |

**Estimated Total: ~3:00-3:30**

---

## Checklist

### Pre-Production
- [ ] VHS tape created with FontSize 32
- [ ] Demo script runs successfully with API keys
- [ ] Full recording captured

### Analysis
- [ ] Stills extracted every 1 second
- [ ] Thumbnails created for analysis
- [ ] ALL stills reviewed
- [ ] Segment boundaries documented
- [ ] Segment count finalized (expect 8-12 VHS segments)

### SVG Slides
- [ ] 01-hook.svg - 96px headlines, 48px body, 6px strokes
- [ ] 02-intro-demo.svg
- [ ] Interstitial separators as needed
- [ ] 99-cta.svg
- [ ] All text verified >= 36px minimum

### Narration
- [ ] All scripts written
- [ ] All scripts verified: no digits, no forbidden punctuation
- [ ] All scripts under 320 chars
- [ ] TTS generated for all
- [ ] Whisper verification passed

### VHS Clips
- [ ] Raw segments extracted
- [ ] Audio/video durations matched
- [ ] All clips normalized to 44100Hz stereo

### Avatar Clips
- [ ] Hook lipsync completed (use both ports 3015/3016)
- [ ] CTA lipsync completed
- [ ] Composited clips created

### Final Assembly
- [ ] Concat list created with absolute paths
- [ ] All clips verified normalized
- [ ] Final video concatenated
- [ ] Duration verified (~3:00-3:30)
- [ ] Audio sync verified at multiple points
