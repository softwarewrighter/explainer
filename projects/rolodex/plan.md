# Rolodex - Production Plan

An explainer video about [TODO: topic description].

> **Reference**: See [Video Pipeline Guide](../../docs/tools.md) for tool documentation.

---

## Project Info

| Field | Value |
|-------|-------|
| **Project** | rolodex |
| **Video Title** | [TODO: Video title] |
| **Subject Repo** | [TODO: ../subject-repo] |
| **Target Duration** | ~4 minutes |
| **Target Audience** | [TODO: Define target audience] |
| **Format** | Animated explainer (SVG + voiceover, avatar on hook/CTA) |
| **Music** | soaring.mp3 (title + epilog extension) |

---

## Research Summary

### What is [Topic]?

[TODO: Research and document the main topic]

- **Origin**: [Where did this come from?]
- **Purpose**: [What problem does it solve?]
- **Key Features**: [Main capabilities]
- **Use Cases**: [Who uses it and why?]

### Key Concepts

[TODO: Define key concepts that need to be explained]

1. **Concept A**: Description
2. **Concept B**: Description
3. **Concept C**: Description

### Technical Details

[TODO: Add relevant technical information]

---

## Narrative Structure

### Part 1: INTRO (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 01-title | Title card + music | (music only, 4s) |
| 02-hook | [Visual description] | "[Hook text - capture attention]" |
| 03-problem | [Visual description] | "[What problem does this solve?]" |
| 04-solution | [Visual description] | "[How does it solve the problem?]" |
| 05-preview | [Visual description] | "[What will we cover today?]" |

### Part 2: BODY (~180s)

#### Section A: [First Topic] (~45s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 06-topic-a | [Visual] | "[Narration]" |
| 07-topic-a-detail | [Visual] | "[Narration]" |
| 08-topic-a-example | [Visual] | "[Narration]" |

#### Section B: [Second Topic] (~45s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 09-topic-b | [Visual] | "[Narration]" |
| 10-topic-b-detail | [Visual] | "[Narration]" |
| 11-topic-b-example | [Visual] | "[Narration]" |

#### Section C: [Third Topic] (~45s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 12-topic-c | [Visual] | "[Narration]" |
| 13-topic-c-detail | [Visual] | "[Narration]" |
| 14-topic-c-example | [Visual] | "[Narration]" |

#### Section D: [Demo/Application] (~45s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 15-demo | [Visual] | "[Narration]" |
| 16-demo-result | [Visual] | "[Narration]" |
| 17-demo-insight | [Visual] | "[Narration]" |

### Part 3: SUMMARY (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 18-recap-a | [Icon for topic A] | "[Key takeaway from section A]" |
| 19-recap-b | [Icon for topic B] | "[Key takeaway from section B]" |
| 20-recap-c | [Icon for topic C] | "[Key takeaway from section C]" |
| 21-key-insight | Lightbulb | "[The main insight viewers should remember]" |
| 22-cta | GitHub links | "[Call to action - links below, thanks for watching]" |

---

## Audio Settings

```bash
# Standard padding for clear pacing
--pad-start 0.3 --pad-end 0.3
```

---

## Visual Requirements

### SVGs Needed (~20 unique visuals)

```
assets/svg/
  02-hook.svg           # Hook visual
  03-problem.svg        # Problem illustration
  04-solution.svg       # Solution preview
  05-preview.svg        # Topic icons
  06-topic-a.svg        # First topic intro
  07-topic-a-detail.svg # First topic detail
  08-topic-a-example.svg # First topic example
  09-topic-b.svg        # Second topic intro
  10-topic-b-detail.svg # Second topic detail
  11-topic-b-example.svg # Second topic example
  12-topic-c.svg        # Third topic intro
  13-topic-c-detail.svg # Third topic detail
  14-topic-c-example.svg # Third topic example
  15-demo.svg           # Demo intro
  16-demo-result.svg    # Demo results
  17-demo-insight.svg   # Demo insight
  18-recap-a.svg        # Recap icon A
  19-recap-b.svg        # Recap icon B
  20-recap-c.svg        # Recap icon C
  21-key-insight.svg    # Key insight
  22-cta.svg            # Call to action
```

---

## Tool Locations

```bash
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR="/Users/mike/github/softwarewrighter/explainer/projects/rolodex/work"
MUSIC="$REFDIR/music/soaring.mp3"

VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
```

---

## Production Steps

### Step 1: Write Scripts
```bash
# One script per segment (max 200 chars, 2 sentences)
work/scripts/02-hook.txt
work/scripts/03-problem.txt
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
# Create ~20 unique SVGs in assets/svg/
# Each should be 1920x1080, dark theme, clear visuals
```

### Step 4: Build Video Clips
```bash
# Title clip with music
$VID_IMAGE --image assets/images/title.jpg \
  --output work/clips/01-title.mp4 \
  --duration 4.0 \
  --music "$MUSIC" \
  --music-offset 15 --volume 0.3

# Content clips with voiceover
for audio in work/audio/*.wav; do
  name=$(basename "$audio" .wav)
  rsvg-convert -w 1920 -h 1080 "assets/svg/${name}.svg" -o "work/stills/${name}.png"
  $VID_IMAGE --image "work/stills/${name}.png" \
    --output "work/clips/${name}.mp4" \
    --audio "$audio" \
    --effect ken-burns
done
```

### Step 5: Avatar Composites (Hook + CTA)
```bash
# Stretch avatar, lipsync, composite for 02-hook and 22-cta
```

### Step 6: Concatenate
```bash
ls work/clips/*.mp4 | sort > work/clips/concat-list.txt
echo "$REFDIR/epilog/99b-epilog.mp4" >> work/clips/concat-list.txt
$VID_CONCAT --list work/clips/concat-list.txt \
  --output work/rolodex-draft.mp4 \
  --reencode
```

---

## YouTube Metadata

### Title
"[TODO: Video title for YouTube]"

### Description
```
[TODO: Write YouTube description]

What you'll learn:
- [Key point 1]
- [Key point 2]
- [Key point 3]

In this video:
- 0:00 Introduction
- 0:30 [Section A]
- 1:15 [Section B]
- 2:00 [Section C]
- 2:45 [Demo]
- 3:30 Summary

Links:
- [GitHub repo URL]
- [Related resources]

#tag1 #tag2 #tag3 #vibecoding
```

---

## Script Guidelines

### Rules for VibeVoice TTS
1. Max 200 characters per script file
2. Max 2 sentences per script file
3. Only periods and commas (no question marks, colons, semicolons)
4. Spell out acronyms: "A P I" not "API", "C L I" not "CLI"
5. Short sentences work best

---

## Segment Summary

| Section | Segments | Est. Duration |
|---------|----------|---------------|
| Intro | 4 narrated | ~25s |
| Topic A | 3 | ~30s |
| Topic B | 3 | ~30s |
| Topic C | 3 | ~30s |
| Demo | 3 | ~30s |
| Summary | 5 | ~30s |
| **Total** | **21 narrated** | **~175s (~2:55)** |

Plus title (4s) + epilog (12.8s) + extension (5s) = **~200s (~3:20)**

---

## Open Questions

1. [TODO: List any open questions about the content or approach]
2. [TODO: Questions about visuals or demonstrations]
3. [TODO: Questions about music or pacing]
