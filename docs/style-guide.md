# Explainer Video Style Guide

Mandatory standards for all video assets. **Never deviate from these values.**

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│  SVG FONTS           │  VHS TERMINAL      │  AUDIO          │
├─────────────────────────────────────────────────────────────┤
│  Headline:    96px   │  FontSize:    32   │  Sample: 44100Hz│
│  Subtitle:    48px   │  Width:     1920   │  Channels: 2    │
│  Body:        36px   │  Height:    1080   │  Max chars: 320 │
│  Labels:      32px   │  Theme:  Dracula   │  No digits      │
│  Minimum:     28px   │  Speed:     50ms   │  No punctuation │
│  Strokes:      5px   │                    │  except . and , │
└─────────────────────────────────────────────────────────────┘
```

---

## 1. VHS Terminal Recording

### Required Settings

```tape
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20
```

| Setting | Value | Rationale |
|---------|-------|-----------|
| FontSize | **32** | Readable at 1080p, survives YouTube compression |
| Width | 1920 | Match video output |
| Height | 1080 | Match video output |
| Theme | Dracula | Consistent dark theme across all videos |
| TypingSpeed | 50ms | Readable pace, not too slow |
| Padding | 20 | Edge buffer |

### Never Use

- FontSize below 28 (too small after compression)
- FontSize 28 is minimum acceptable (32 recommended)
- Custom themes (inconsistent branding)

### Command Pattern

Always put entire bash command on ONE line:

```tape
# CORRECT
Type "./rlm file.txt 'query' --flag1 --flag2"
Enter

# WRONG - splits into multiple commands
Type "./rlm file.txt"
Enter
Type "'query'"
Enter
```

---

## 2. SVG Slide Design

**Critical:** Design for phone viewing. Text must be readable on a 6-inch screen.

### Font Size Requirements

| Element | Minimum | Recommended | Example Use |
|---------|---------|-------------|-------------|
| Main headline | 96px | **96px** | "Try RLM Today" (bold) |
| Subtitle | 56px | **64px** | "Level 4: LLM Analysis" |
| Body text | 48px | **48px** | Paragraph content |
| Box titles | 48px | **48px** | Section headers (bold) |
| Box content | 40px | **44px** | List items, descriptions |
| Diagram labels | 40px | **44px** | Flow diagram boxes |
| Smallest allowed | 36px | 40px | Captions, annotations |

### Consistency Rules

- **Same section = same size**: All body text within a box must be the same font size
- **Bold for emphasis**: Use font-weight="bold" for titles, not smaller sizes for body
- **No size hierarchy tricks**: Don't make secondary text smaller to fit - redesign instead
- **When in doubt, go bigger**: 48px body text is better than 36px

### Stroke Width Requirements

| Element | Minimum | Recommended |
|---------|---------|-------------|
| Box borders | 5px | **6px** |
| Flow arrows | 5px | **6px** |
| Diagram lines | 5px | **6px** |
| Decorative | 4px | 5px |

### Layout Standards

- **Canvas**: Always 1920x1080 viewBox
- **Safe margins**: 100px on all sides
- **Avatar zone**: Keep bottom-right 520x280 clear for overlay
- **Text anchor**: Use `text-anchor="middle"` for centered text

### Color Palette

Use Dracula-based colors for consistency:

| Name | Hex | Usage |
|------|-----|-------|
| Background Dark | #0f0c29 | Primary background (gradient start) |
| Background Mid | #302b63 | Gradient middle |
| Background End | #24243e | Gradient end |
| Card Fill | #1a1a3e / #0d0d1a | Card gradient (top/bottom) |
| Terminal BG | #0a0a14 | Code/terminal mockups |
| Cyan | #00d4ff | Headlines, primary accent |
| Red | #ff6b6b | Warnings, emphasis, challenges |
| Green | #4ade80 | Success, positive, solutions |
| Yellow | #ffd93d | Highlights, secondary accent |
| Purple | #a855f7 | AI/future features |
| Text Primary | #fff / #eee | Headlines, body text |
| Text Secondary | #ccc / #aaa | Descriptions, muted labels |
| Text Muted | #888 | Captions, annotations |

---

## 2.5 Modern Visual Design (PaperBanana Style)

**CRITICAL: Slides must be visually engaging, not boring boxes.**

Avoid repetitive box-and-border layouts. Use modern design principles inspired by PaperBanana academic illustrations.

### Required Visual Elements

Every slide MUST include at least 3 of these:

1. **Rich gradient backgrounds** - Not flat colors
2. **Decorative shapes** - Circles, polygons with low opacity
3. **Emoji/icon embellishments** - Relevant icons (🚀 ⚡ 🔍 💡 🎯 ✨)
4. **Terminal mockups** - With colored window dots (red/yellow/green)
5. **Glow filters** - For emphasis on key elements
6. **Colored accent bars** - Top borders on cards
7. **Visual comparison** - Before/after, problem/solution layouts
8. **Checkmarks and X marks** - For lists (✓ ✗)
9. **Arrow transitions** - Animated-looking flow arrows
10. **Pill/chip elements** - For tags, aliases, options

### Background Template

Always use rich gradients, not flat colors:

```svg
<defs>
  <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
    <stop offset="0%" style="stop-color:#0f0c29"/>
    <stop offset="50%" style="stop-color:#302b63"/>
    <stop offset="100%" style="stop-color:#24243e"/>
  </linearGradient>
  <filter id="glow" x="-50%" y="-50%" width="200%" height="200%">
    <feGaussianBlur stdDeviation="6" result="blur"/>
    <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
  </filter>
  <linearGradient id="cardGrad" x1="0%" y1="0%" x2="0%" y2="100%">
    <stop offset="0%" style="stop-color:#1a1a3e;stop-opacity:0.9"/>
    <stop offset="100%" style="stop-color:#0d0d1a;stop-opacity:0.9"/>
  </linearGradient>
</defs>
```

### Decorative Elements

Add subtle visual interest:

```svg
<!-- Decorative circles -->
<circle cx="150" cy="150" r="200" fill="#ff6b6b" opacity="0.08"/>
<circle cx="1800" cy="900" r="300" fill="#4ade80" opacity="0.06"/>

<!-- Emoji embellishments -->
<text x="100" y="150" font-size="60" opacity="0.3">✨</text>
```

### Card Design

Use gradient fills with colored top borders:

```svg
<rect x="100" y="200" width="800" height="400" rx="24" fill="url(#cardGrad)"/>
<rect x="100" y="200" width="800" height="8" rx="4" fill="#4ade80"/>
```

### Terminal Mockups

Include window chrome for authenticity:

```svg
<rect x="150" y="300" width="720" height="80" rx="12" fill="#0a0a14"/>
<circle cx="180" cy="340" r="8" fill="#ff6b6b"/>
<circle cx="210" cy="340" r="8" fill="#ffd93d"/>
<circle cx="240" cy="340" r="8" fill="#4ade80"/>
<text x="280" y="350" font-family="Courier New" font-size="36" fill="#4ade80">
  $ command here
</text>
```

### Visual Comparison Layout

Problem vs Solution pattern:

```svg
<!-- Left: Problem (red accent) -->
<rect ... fill="url(#cardGrad)"/>
<rect ... fill="#ff6b6b"/>  <!-- top bar -->
<text>🚫</text>
<text fill="#ff6b6b">The Challenge</text>

<!-- Arrow transition -->
<polygon points="..." fill="#ffd93d"/>

<!-- Right: Solution (green accent) -->
<rect ... fill="url(#cardGrad)"/>
<rect ... fill="#4ade80"/>  <!-- top bar -->
<text>💡</text>
<text fill="#4ade80">The Solution</text>
```

### What NOT to Do

❌ Flat single-color backgrounds
❌ Plain rectangular boxes with just colored borders
❌ No visual embellishments or icons
❌ Same layout for every slide
❌ No terminal mockups for CLI tools
❌ Missing comparison/contrast visuals
❌ Boring repetitive color schemes

### SVG Template (Modern)

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1920 1080">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1a1a2e"/>
      <stop offset="100%" style="stop-color:#16213e"/>
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="1920" height="1080" fill="url(#bgGrad)"/>

  <!-- Headline: 96px bold -->
  <text x="960" y="150" font-family="Arial, sans-serif" font-size="96"
        font-weight="bold" fill="#00d4ff" text-anchor="middle">
    Main Headline Here
  </text>

  <!-- Subtitle: 64px -->
  <text x="960" y="240" font-family="Arial, sans-serif" font-size="64"
        fill="#ffd93d" text-anchor="middle">
    Subtitle Text
  </text>

  <!-- Content box with 6px stroke -->
  <rect x="200" y="320" width="700" height="400" rx="16"
        fill="#0f0f23" stroke="#4ade80" stroke-width="6"/>

  <!-- Box title: 48px bold -->
  <text x="250" y="400" font-family="Arial, sans-serif" font-size="48"
        font-weight="bold" fill="#4ade80">
    Box Title
  </text>

  <!-- Body text: 44px (same size for all items) -->
  <text x="250" y="480" font-family="Arial, sans-serif" font-size="44"
        fill="#eee">
    Body text content here
  </text>
  <text x="250" y="540" font-family="Arial, sans-serif" font-size="44"
        fill="#eee">
    Second line same size
  </text>

  <!-- Avatar safe zone (keep clear) -->
  <rect x="1400" y="800" width="520" height="280" fill="transparent"/>
</svg>
```

---

## 3. TTS Narration

### Character Limits

- Maximum: **320 characters** per script segment
- Recommended: 200-280 characters for natural pacing

### Allowed Characters

- Letters: A-Z, a-z
- Numbers: Spelled out as words only
- Punctuation: Period (.) and comma (,) only

### Forbidden Characters

Never use in narration scripts:
- Apostrophes (')
- Hyphens (-)
- Dashes (— –)
- Exclamation points (!)
- Question marks (?)
- Semicolons (;)
- Colons (:)
- Quotes (" ')
- Slashes (/)
- Digits (0-9)

### Number Formatting

**Always spell out numbers as approximate words:**

| Wrong | Correct |
|-------|---------|
| 65,660 lines | sixty thousand lines |
| 3.3 megabytes | over three megabytes |
| 80% reduction | eighty percent reduction |
| 19,991 chars | about twenty thousand characters |

### Acronym Replacements

| Acronym | Replacement |
|---------|-------------|
| LLM | Language Model |
| RLM | Recursive Language Model |
| CLI | command line |
| API | A P I |
| WASM | Web Assembly |

---

## 4. Audio Standards

### Format Requirements

All audio must be normalized before concatenation:

| Property | Required Value |
|----------|----------------|
| Sample rate | 44100 Hz |
| Channels | 2 (stereo) |
| Target loudness | -25 dB |

### Normalization Command

```bash
./scripts/normalize-volume.sh clip.mp4
```

Run this on EVERY clip before concatenation.

---

## 5. Video Concatenation

### Use vid-concat Only

**Never use raw ffmpeg for concatenation.**

```bash
# Create concat list (absolute paths, no "file '...'" prefix)
/full/path/to/clips/00-title.mp4
/full/path/to/clips/01-hook.mp4
...

# Concatenate
$VID_CONCAT --list clips/concat-list.txt --output preview.mp4 --reencode
```

---

## 6. Quality Checklist

Before finalizing any asset, verify:

### SVG Checklist
- [ ] No text smaller than 36px (prefer 40px+)
- [ ] Headlines 84-96px bold
- [ ] Subtitles at least 48px (prefer 52px)
- [ ] Box content at least 38px (prefer 40px)
- [ ] All stroke widths at least 5px (prefer 6px)
- [ ] Same font size for all text in same section
- [ ] Bold used for emphasis, not smaller sizes
- [ ] Text fits within boxes with generous padding
- [ ] Avatar zone (bottom-right) kept clear
- [ ] Designed for phone screen readability
- [ ] **Uses rich gradient background (not flat)**
- [ ] **Has at least 3 visual embellishments (icons, shapes, emojis)**
- [ ] **Includes terminal mockups for CLI content**
- [ ] **Has decorative elements (circles, glows, patterns)**
- [ ] **Uses colored top bars on cards, not just borders**

### VHS Checklist
- [ ] FontSize set to 32
- [ ] Width/Height set to 1920x1080
- [ ] Theme set to Dracula
- [ ] All commands on single lines
- [ ] Environment variables loaded with export pattern

### TTS Checklist
- [ ] Under 320 characters
- [ ] No digits (spelled out as words)
- [ ] No forbidden punctuation
- [ ] Acronyms spelled out
- [ ] Verified with whisper transcription

### Audio Checklist
- [ ] Normalized to 44100Hz stereo
- [ ] Volume normalized to -25dB
- [ ] Verified with whisper

---

## 7. Common Mistakes to Avoid

| Mistake | Why It Happens | Correct Approach |
|---------|----------------|------------------|
| FontSize under 32 in VHS | Assuming monitor clarity = video clarity | Always use 32 |
| Sub-40px text in SVG | Fitting too much content | Reduce content, use 40px+ |
| Varying sizes in boxes | Creating "hierarchy" | Same size, bold for titles |
| 2-4px strokes | Looks fine on monitor | Use 5-6px for video |
| **Flat backgrounds** | Quick prototyping | **Use rich gradients** |
| **Plain boxes** | Default thinking | **Add embellishments, icons** |
| **No visual interest** | Functional focus | **Include emojis, shapes, glows** |
| **Same layout every slide** | Template reuse | **Vary layouts, use comparisons** |
| Digits in TTS | Copy-paste from visuals | Spell out as words |
| Split VHS commands | Multi-line formatting | Single Type + Enter |
| Skip normalization | Clip sounds fine | Always normalize |

---

## Version History

- 2026-03-04: Added PaperBanana-style modern visual design requirements
- 2026-01-20: Initial version based on rlm-llm-big project learnings
