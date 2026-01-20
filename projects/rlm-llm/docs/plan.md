# RLM Level 4 Video Production Plan

## Video Structure Overview

| # | Segment | Duration | Type | Tools |
|---|---------|----------|------|-------|
| 00 | Title Card | 5s | Image + music | vid-image |
| 01 | Hook | ~15s | SVG + avatar + narration | vid-tts, vid-image, vid-lipsync, vid-composite |
| 02 | L4 Introduction | ~20s | SVG + narration | vid-tts, vid-image |
| 03 | Architecture Diagram | ~15s | SVG + narration | vid-tts, vid-image |
| 04 | Demo Intro (War & Peace) | ~15s | SVG + narration | vid-tts, vid-image |
| 05a-c | Script Demo (VHS) | ~40s | VHS recording + narration | VHS, vid-tts, ffmpeg |
| 06 | Visualizer Intro | ~15s | SVG + narration | vid-tts, vid-image |
| 07a-c | Visualizer Demo | ~60s | OBS recording + narration | OBS, vid-tts, ffmpeg |
| 08 | Results/Comparison | ~15s | SVG + narration | vid-tts, vid-image |
| 99 | CTA | ~15s | SVG + avatar + narration | vid-tts, vid-image, vid-lipsync, vid-composite |
| 99b | Epilog | ~13s | Standard epilog | (pre-built) |
| 99c | Epilog Extension | 5s | Music fade | vid-image |

**Estimated Total: ~3:30 - 4:00**

---

## Step-by-Step Production Plan

### Step 1: Title Card (00-title)
**Tools:** vid-image, music file
**Assets needed from you:**
- Title image (1920x1080 JPG/PNG) showing L4 concept
- OR I create title SVG

**Process:**
```bash
vid-image --image assets/images/title.jpg --output work/clips/00-title.mp4 \
  --duration 5 --music "$MUSIC" --music-offset 0 --volume 0.3 --fade-in 0.5 --fade-out 0.5
```

---

### Step 2: Hook (01-hook)
**Tools:** vid-tts, vid-image, vid-avatar, vid-lipsync, vid-composite
**Assets needed:**
- Hook SVG slide (I create)
- Narration script (I write, you approve)

**Hook concept:** "What happens when your data won't fit in any context window. Three million characters is too much for any model. But Level 4 breaks it into pieces, analyzes each one, and brings it all together."

**Process:**
1. Create hook SVG → PNG
2. Generate TTS audio
3. Create base video from PNG
4. Stretch avatar, lip-sync, composite
5. Normalize audio

---

### Step 3: L4 Introduction (02-intro-l4)
**Tools:** vid-tts, vid-image, rsvg-convert
**Assets needed:**
- L4 intro SVG (I create)

**Content:** Explain the chunk-delegate-aggregate pattern. Show how L1/L2/L3 reduce data, then L4 handles analysis that requires reasoning.

---

### Step 4: Architecture Diagram (03-architecture)
**Tools:** vid-tts, vid-image
**Assets needed:**
- Architecture SVG showing the flow (I create)

**Content:** Visual diagram of:
```
Input → L1/L2/L3 Extract → Chunk → Sub-LLM × N → Aggregate → Answer
```

---

### Step 5: Demo Intro - War & Peace (04-intro-demo)
**Tools:** vid-tts, vid-image
**Assets needed:**
- Demo intro SVG (I create)

**Content:** "War and Peace is 3.2 megabytes, over 580,000 words. We'll extract character relationships and build a family tree."

---

### Step 6: Script Demo (05a-c) - VHS Recording
**Tools:** VHS, vid-tts, ffmpeg
**Assets needed from you:**
- Working L4 demo script in rlm-project repo
- OR VHS tape file if you've recorded it

**Process:**
1. Record terminal demo with VHS showing L4 execution
2. Extract stills, identify segments (setup, processing, results)
3. Write narration for each segment
4. Generate TTS, mix with video clips
5. Normalize audio

**Segments:**
- 05a: Demo setup (load War & Peace, show query)
- 05b: Processing (L1 extraction, chunking, sub-LLM calls)
- 05c: Results (family tree output)

---

### Step 7: Visualizer Intro (06-intro-viz)
**Tools:** vid-tts, vid-image
**Assets needed:**
- Visualizer intro SVG (I create)

**Content:** "Watch the visualizer show L4 in action. See how chunks are processed in parallel and results aggregated."

---

### Step 8: Visualizer Demo (07a-c) - OBS Recording
**Tools:** OBS, vid-tts, ffmpeg (with scaling to 1920x1080)
**Assets needed from you:**
- OBS recording of visualizer running L4 demo
- OR access to run visualizer myself

**Process:**
1. Extract stills every 0.5s
2. Create thumbnails (≤1200px for API)
3. Identify segment boundaries
4. Extract clips with scaling to 1920x1080
5. Write narration, generate TTS
6. Adjust video speed to match audio + 0.5s
7. Normalize all clips

---

### Step 9: Results/Comparison (08-comparison)
**Tools:** vid-tts, vid-image
**Assets needed:**
- Results SVG showing family tree output
- Optional: comparison with naive approach

---

### Step 10: CTA (99-cta)
**Tools:** vid-tts, vid-image, vid-lipsync, vid-composite
**Assets needed:**
- CTA SVG with GitHub link (I create)

**Content:** Links to paper and repo, call to explore L4 implementation.

---

### Step 11: Epilog (99b-epilog)
**Tools:** Pre-built standard epilog
**Assets:** Use existing epilog from reference folder

---

### Step 12: Epilog Extension (99c-epilog-ext)
**Tools:** vid-image
**Assets:** Last frame of epilog + music fade

---

## What I Need From You to Start

### For Step 1 (Title Card):
**Option A:** Provide a title image (1920x1080)
- Screenshot of L4 in action, or
- Concept art showing chunk-delegate-aggregate, or
- War & Peace book cover with L4 overlay

**Option B:** I create a title SVG
- Just confirm the title text you want (e.g., "RLM Level 4: LLM-Based Analysis" or "When Context Isn't Enough")

### For Demo Steps (5 & 8):
- Is there a working L4 demo I can record with VHS?
- Is the visualizer ready to show L4 execution?
- If not ready, what's the timeline?

---

## Parallel Work I Can Do Now

While waiting for demo recordings, I can create:
1. All SVG slides (hook, intro, architecture, demo intro, viz intro, results, CTA)
2. All narration scripts
3. Generate TTS for approved scripts
4. Title card (once you provide image or approve SVG)
5. Hook and CTA clips (with avatar)

Let me know which option for the title and whether demos are ready!
