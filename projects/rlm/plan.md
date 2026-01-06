# RLM Explainer Video - Production Plan v2

A short explainer video about Recursive Language Models (RLM) using static SVG visuals with voiceover.

> **Reference**: See [Video Pipeline Guide](../video-publishing/reference/docs/video-pipeline-guide.md) for general pipeline steps and commands.

---

## Project Info

| Field | Value |
|-------|-------|
| **Project** | explainer |
| **Video Title** | Recursive Language Models: Expanding the Workspace |
| **Subject Repo** | ../rlm-project |
| **Target Duration** | ~3 minutes |
| **Format** | Animated explainer (static SVG + voiceover, no avatar) |
| **Paper Reference** | https://arxiv.org/html/2512.24601v1 |

---

## v2 Improvements (from v1 feedback)

### Issues Identified
1. **Not enough visual change** - slides remained static across multiple narrations
2. **Too much pause between narrations** - default 1s padding too long
3. **Story incomplete and jumbled** - missing proper structure
4. **No MIT paper reference** - need to credit inspiration
5. **No project repo description** - need to explain what rlm-project does
6. **Mixed metaphors** - used both cookie jar AND library (confusing)
7. **No animation** - static images boring
8. **Narration too slow** - need slight speedup

### v2 Solutions
1. **One SVG per narration segment** - no reuse across segments
2. **Reduce padding** - use `--pad-start 0.3 --pad-end 0.3`
3. **Classic 3-part structure**:
   - INTRO: Tell 'em what you're gonna tell 'em
   - BODY: Tell 'em (with ELI5 cookie jar analogy)
   - SUMMARY: Tell 'em what you told 'em
4. **Reference MIT paper** explicitly in intro
5. **Describe rlm-project repo** in implementation section
6. **Cookie jar only** - drop library metaphor entirely
7. **Request animation tools** - see Feature Requests below
8. **Speed up audio** - use vid-speedup on final or request audio speedup

---

## Narrative Structure (v2)

### Part 1: INTRO - "Tell 'em what you're gonna tell 'em" (~20s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 01-title | Title card (rlm.jpg) + music | (music only, 4s) |
| 02-hook | Problem visual | "What happens when AI needs to search through millions of words?" |
| 03-paper | Paper citation visual | "A team at MIT found a clever solution. They call it Recursive Language Models." |
| 04-preview | Three-part preview | "Today we will explore the problem, the solution, and the dramatic results." |

### Part 2: BODY - "Tell 'em" (~100s)

#### Section A: The Problem (~25s)
| Segment | Visual | Narration |
|---------|--------|-----------|
| 05-context-limit | Context window diagram | "Large language models have a hard limit. They can only think about so much text at once." |
| 06-overflow | Cookie jar overflowing | "Imagine a cookie jar that holds 100 cookies. What if you need to search through 10000?" |
| 07-context-rot | Degraded data visual | "When you force too much in, the model forgets things. This is called context rot." |
| 08-problem-summary | Red X on overflow | "Bigger models help, but the limit always exists. We need a different approach." |

#### Section B: The Solution (~35s)
| Segment | Visual | Narration |
|---------|--------|-----------|
| 09-rlm-intro | RLM logo/concept | "Recursive Language Models flip the problem. Instead of bigger jars, use better tools." |
| 10-context-box | Box with tools | "The data stays in a context box. The model gets tools to peek inside." |
| 11-tool-slice | Slice operation | "One tool slices the data. Give me bytes 200 to 400." |
| 12-tool-find | Find operation | "Another tool searches. Find all lines containing ERROR." |
| 13-tool-query | Query operation | "A third tool asks questions. Summarize this chunk for me." |
| 14-deliberate | Focused commands | "Small, focused, deliberate. The model thinks about what it needs, then asks for just that." |

#### Section C: The Implementation (~25s)
| Segment | Visual | Narration |
|---------|--------|-----------|
| 15-json-now | JSON commands | "Right now, commands are simple JSON. Slice here. Find this. Count that." |
| 16-wasm-future | WebAssembly visual | "The future is WebAssembly. Custom code running in a safe sandbox." |
| 17-repo-intro | GitHub repo visual | "Our implementation is open source. The rlm-project repo on GitHub." |
| 18-repo-features | Feature list | "It includes the context box, command parser, and sample tasks from the paper." |

#### Section D: ELI5 Cookie Jar (~15s)
| Segment | Visual | Narration |
|---------|--------|-----------|
| 19-eli5-intro | Cookie jar | "Think of it like this. You have a giant cookie jar." |
| 20-old-way | Dumping cookies | "The old way dumps everything on the table. Then digs through the mess." |
| 21-new-way | Using tools | "The RLM way uses a scoop. Grab just the cookies you need." |

### Part 3: SUMMARY - "Tell 'em what you told 'em" (~25s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 22-results-intro | Gauge at 0% | "The results are dramatic. On tasks that do not fit in context, base models score zero." |
| 23-results-rlm | Gauge at 91% | "With Recursive Language Models, accuracy jumps to 91 percent." |
| 24-key-insight | Tagline visual | "The key insight is simple. Expand the workspace, not the context." |
| 25-cta | GitHub + paper links | "Links to the paper and code are in the description. Thanks for watching." |

---

## Audio Settings (v2)

```bash
# Reduced padding for faster pacing
--pad-start 0.3 --pad-end 0.3

# Example:
$VID_TTS --script work/scripts/02-hook.txt \
  --output work/audio/02-hook.wav \
  --pad-start 0.3 --pad-end 0.3 \
  --print-duration
```

---

## Visual Requirements (v2)

### New SVGs Needed (25 unique visuals)

```
assets/svg/
  01-title.svg          # Title card (or use rlm.jpg)
  02-hook.svg           # Question mark / searching visual
  03-paper.svg          # MIT paper citation
  04-preview.svg        # Three-part roadmap
  05-context-limit.svg  # Window with limit indicator
  06-overflow.svg       # Cookie jar overflowing
  07-context-rot.svg    # Degraded/foggy data
  08-problem-summary.svg # Red X, problem statement
  09-rlm-intro.svg      # RLM concept/logo
  10-context-box.svg    # Box with peek hole
  11-tool-slice.svg     # Slice operation visual
  12-tool-find.svg      # Search/find operation
  13-tool-query.svg     # Query/summarize operation
  14-deliberate.svg     # Focused, minimal commands
  15-json-now.svg       # JSON command examples
  16-wasm-future.svg    # WebAssembly hexagon
  17-repo-intro.svg     # GitHub repo visual
  18-repo-features.svg  # Feature checklist
  19-eli5-intro.svg     # Cookie jar intro
  20-old-way.svg        # Dumping cookies (bad)
  21-new-way.svg        # Using scoop (good)
  22-results-intro.svg  # Gauge at 0%
  23-results-rlm.svg    # Gauge at 91%
  24-key-insight.svg    # Tagline: "Expand workspace, not context"
  25-cta.svg            # Links and thanks
```

---

## Tool Locations

```bash
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR="/Users/mike/github/softwarewrighter/explainer/work"

VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_CONCAT="$TOOLS/vid-concat"
VID_MUSIC="$TOOLS/vid-music"
VID_SPEEDUP="$TOOLS/vid-speedup"
```

---

## Production Steps (v2)

### Step 1: Write Scripts
```bash
# One short script per segment (max 200 chars, 2 sentences)
# Use simple punctuation (periods, commas only)
work/scripts/02-hook.txt
work/scripts/03-paper.txt
# ... etc
```

### Step 2: Generate Audio
```bash
for script in work/scripts/*.txt; do
  name=$(basename "$script" .txt)
  $VID_TTS --script "$script" \
    --output "work/audio/${name}.wav" \
    --pad-start 0.3 --pad-end 0.3 \
    --print-duration
done
```

### Step 3: Create SVGs
```bash
# Create 25 unique SVGs in assets/svg/
# Each should be 1920x1080, dark theme, clear visuals
```

### Step 4: Convert SVGs to PNG
```bash
for svg in assets/svg/*.svg; do
  name=$(basename "$svg" .svg)
  rsvg-convert -w 1920 -h 1080 "$svg" -o "work/png/${name}.png"
done
```

### Step 5: Build Video Clips
```bash
# Title clip with music
$VID_IMAGE --image work/png/01-title.png \
  --output work/clips/01-title.mp4 \
  --duration 4.0 \
  --music "$REFDIR/music/swing9.mp3" \
  --music-offset 15 --volume 0.3

# Content clips with voiceover
for audio in work/audio/*.wav; do
  name=$(basename "$audio" .wav)
  dur=$(ffprobe -i "$audio" -show_entries format=duration -v quiet -of csv="p=0")
  $VID_IMAGE --image "work/png/${name}.png" \
    --output "work/clips/${name}.mp4" \
    --duration "$dur" \
    --music "$audio" \
    --volume 1.0 --fade-in 0 --fade-out 0
done
```

### Step 6: Concatenate
```bash
ls work/clips/*.mp4 | sort > work/clips/concat-list.txt
$VID_CONCAT --list work/clips/concat-list.txt \
  --output work/draft-v2.mp4 \
  --reencode
```

### Step 7: Optional Speedup
```bash
# If narration feels slow, speed up slightly (1.1x)
$VID_SPEEDUP --input work/draft-v2.mp4 \
  --output work/draft-v2-fast.mp4 \
  --speed 1.1
```

---

## Feature Requests for Rust CLI Tools

### 1. vid-speedup: Audio Support
**Current**: Only speeds up video, mutes audio by default
**Request**: Add `--keep-audio` flag to speed up audio proportionally (pitch correction optional)

```bash
# Requested usage:
$VID_SPEEDUP --input video.mp4 --output fast.mp4 --speed 1.1 --keep-audio

# Optional pitch correction:
$VID_SPEEDUP --input video.mp4 --output fast.mp4 --speed 1.1 --keep-audio --preserve-pitch
```

### 2. vid-tween: SVG Animation Tool (NEW)
**Purpose**: Create animated transitions between SVG frames
**Use case**: Add visual interest to static explainer videos

```bash
# Requested usage:
$VID_TWEEN --start assets/svg/start.svg \
  --end assets/svg/end.svg \
  --output work/clips/transition.mp4 \
  --duration 2.0 \
  --easing ease-in-out \
  --effect crossfade  # or: zoom, pan, morph

# Effects:
# - crossfade: Opacity transition between SVGs
# - zoom: Ken Burns style zoom
# - pan: Horizontal/vertical pan
# - morph: Interpolate SVG paths (advanced)
```

### 3. vid-concat: Transition Support
**Current**: Hard cuts between clips
**Request**: Add optional transitions between clips

```bash
# Requested usage:
$VID_CONCAT --list concat.txt \
  --output final.mp4 \
  --transition crossfade \
  --transition-duration 0.3
```

### 4. vid-image: Ken Burns Effect
**Current**: Static image to video
**Request**: Add subtle motion (zoom/pan) for visual interest

```bash
# Requested usage:
$VID_IMAGE --image photo.jpg --output clip.mp4 \
  --duration 5.0 \
  --effect ken-burns \
  --zoom-start 1.0 --zoom-end 1.1 \
  --pan-direction right
```

### 5. vid-audio-speed: Audio-Only Speedup (NEW)
**Purpose**: Speed up audio files without video processing
**Use case**: Adjust narration pacing before building clips

```bash
# Requested usage:
$VID_AUDIO_SPEED --input narration.wav \
  --output narration-fast.wav \
  --speed 1.1 \
  --preserve-pitch  # Optional
```

---

## YouTube Metadata (v2)

### Title
"Recursive Language Models: How AI Searches 10 Million Tokens"

### Description
```
How do you search through 10 million tokens without running out of memory?

A team at MIT found the answer: Recursive Language Models (RLM).

Instead of cramming everything into context, RLM gives AI tools to explore data on demand. The result? 91% accuracy on tasks where standard models score 0%.

In this video:
- 0:00 Introduction
- 0:20 The Problem (context limits)
- 0:45 The Solution (RLM tools)
- 1:20 Implementation (JSON commands, WebAssembly future)
- 1:45 ELI5 (cookie jar analogy)
- 2:00 Results (91% accuracy)
- 2:25 Key Insight

Paper: https://arxiv.org/html/2512.24601v1
Code: https://github.com/softwarewrighter/rlm-project

#AI #LLM #RecursiveLanguageModels #ContextWindow #MachineLearning #MIT
```

---

## Script Guidelines (v2)

### Rules for VibeVoice TTS
1. Max 200 characters per script file
2. Max 2 sentences per script file
3. Only periods and commas (no dashes, colons, semicolons, ?, !)
4. Short sentences work best
5. Split long narrations into multiple files

### Pacing
- Use `--pad-start 0.3 --pad-end 0.3` for tight pacing
- Consider 1.1x speedup on final video if still too slow

---

## File Organization (v2)

```
explainer/
+-- plan.md              # This file
+-- docs/
|   +-- tools.md         # Tool documentation
+-- work/
|   +-- scripts/         # Narration text (01-*.txt through 25-*.txt)
|   +-- audio/           # TTS audio (.wav)
|   +-- png/             # Converted SVGs
|   +-- clips/           # Individual video clips
|   +-- draft-v2.mp4     # Concatenated draft
+-- assets/
|   +-- images/
|   |   +-- rlm.jpg      # Title image
|   +-- svg/             # 25 unique SVG visuals
+-- out/
    +-- final.mp4        # Final video
```
