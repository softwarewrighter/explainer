# RLM Level 4 Video: War and Peace Family Tree

## Video Structure Overview

| # | Segment | Duration | Type | Status |
|---|---------|----------|------|--------|
| 00 | Title Card | 6s | Image + music | ✓ |
| 01 | Hook | ~15s | SVG + narration | pending |
| 02 | Intro to VHS Demo | ~15s | SVG + narration | pending |
| 03 | VHS Demo | ~60s | VHS recording + narration | pending |
| 04 | Intro to Visualization | ~15s | SVG + narration | pending |
| 05 | Visualization Demo | ~60s | OBS recording + narration | pending |
| 06 | Summary | ~15s | SVG + narration | pending |
| 07 | CTA | ~15s | SVG + avatar + narration | pending |
| 99b | Epilog | ~11s | Standard epilog + narration | ✓ |
| 99c | Epilog Extension | 12s | Epilog image + music fade | ✓ |

**Estimated Total: ~3:30 - 4:00**

---

## Assets

### Title Card (00-title)
- **Image:** assets/images/rlm-turtle-llms.jpg (1344x768 → scaled to 1920x1080)
- **Music:** assets/music/take-it-over.mp3 (Take It Over - Ryan Stasik, Kanika Moore)
- **Duration:** 6s with music fade in/out

### Epilog (99b-epilog)
- **Image:** work/stills/99b-epilog.png (standard "Like & Subscribe" slide)
- **Narration:** "If you found this helpful, please like and subscribe. Hit the bell for notifications and leave a comment if you have questions. See you in the next one."
- **Duration:** ~11s

### Epilog Extension (99c-epilog-ext)
- **Image:** Same as 99b-epilog (NOT the title image)
- **Audio:** Music only (no narration), fade out at end
- **Duration:** 12s

---

## Production Steps

### Step 1: Title Card (00-title) ✓
```bash
ffmpeg -y -loop 1 -i work/stills/title-scaled.jpg -i assets/music/take-it-over.mp3 \
  -t 6 \
  -filter_complex "[1:a]afade=t=in:st=0:d=1,afade=t=out:st=4.5:d=1.5,volume=0.4[a]" \
  -map 0:v -map "[a]" \
  -c:v libx264 -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  -shortest \
  work/clips/00-title.mp4
```

### Step 2: Hook (01-hook)
- Create hook SVG
- Write narration script
- Generate TTS
- Create clip from SVG + audio

### Step 3: VHS Demo Intro (02-intro-demo)
- Create intro SVG
- Write narration script
- Generate TTS
- Create clip

### Step 4: VHS Demo Recording (03-vhs-demo)
- Record terminal demo with VHS
- Extract segments
- Write narration for each segment
- Combine with TTS

### Step 5: Visualization Intro (04-intro-viz)
- Create intro SVG
- Write narration script
- Generate TTS
- Create clip

### Step 6: Visualization Demo (05-viz-demo)
- Record OBS demo of visualizer
- Scale to 1920x1080
- Write narration
- Combine with TTS

### Step 7: Summary (06-summary)
- Create summary SVG
- Write narration script
- Generate TTS
- Create clip

### Step 8: CTA (07-cta)
- Create CTA SVG
- Write narration script
- Generate TTS
- Lip-sync with avatar
- Composite

### Step 9: Epilog (99b-epilog) ✓
Standard epilog with narration using "Like & Subscribe" image.

### Step 10: Epilog Extension (99c-epilog-ext) ✓
Same image as 99b-epilog with music fade out (no narration).

---

## Concat List

```
work/clips/concat-list.txt

00-title.mp4           ✓
01-hook.mp4
02-intro-demo.mp4
03-vhs-demo.mp4
04-intro-viz.mp4
05-viz-demo.mp4
06-summary.mp4
07-cta-composited.mp4
99b-epilog.mp4         ✓
99c-epilog-ext.mp4     ✓
```

---

## Key Differences from rlm-llm Project

1. **Topic:** War and Peace family tree extraction (not murder mystery)
2. **Demo:** L4 extracts character relationships from 3.2MB novel
3. **Title image:** rlm-turtle-llms.jpg (different from epilog)
4. **Epilog image:** Standard "Like & Subscribe" slide (same across all videos)
