# Ralphy Video Production Plan

## Overview

This video introduces Ralphy, a parallel orchestration tool for video publishing. It demonstrates how Ralphy can parallelize tasks in the video production pipeline, using the next RLM video (L3 Rust CLI) as the example.

## Series Context

| # | Video | Focus | Status |
|---|-------|-------|--------|
| 1 | RLM Intro | L1 DSL basics | Published |
| 2 | RLM WASM | L2 WebAssembly | Done |
| 3 | **Ralphy** | Parallel orchestration | **This video** |
| 4 | RLM Rust CLI | L3 Native execution | Next |

## Video Structure

| Segment | Type | Content | Est. Duration |
|---------|------|---------|---------------|
| 00-title | Image + music | Title card with "The Creepy Clown" | 5s |
| 01-hook | Avatar | Why parallel? Video tasks are slow | ~15s |
| 02-problem | SVG + narration | Sequential pipeline bottlenecks | ~15s |
| 03-ralphy-intro | SVG + narration | What is Ralphy? Task graph orchestration | ~20s |
| 04-demo | Screen recording | Ralphy running on RLM L3 video tasks | ~60s |
| 05-benefits | SVG + narration | Speedup, visibility, reproducibility | ~15s |
| 14-cta | Avatar | Try Ralphy, next video teaser | ~12s |
| 99-epilog | Reference | Standard epilog | ~13s |
| 99-ext | Music fade | Outro music | 5s |

**Estimated total: ~2:40**

## Production Steps

### Phase 1: Assets (Parallelizable)
- [ ] Title image -> title clip (DONE)
- [ ] Create SVG: problem diagram (sequential bottlenecks)
- [ ] Create SVG: Ralphy architecture (task graph)
- [ ] Create SVG: benefits summary

### Phase 2: Scripts & TTS (Sequential per script)
- [ ] Write hook narration script
- [ ] Write problem narration script
- [ ] Write Ralphy intro script
- [ ] Write benefits script
- [ ] Write CTA script
- [ ] Generate TTS for all scripts

### Phase 3: Demos (Can start after Ralphy is ready)
- [ ] Set up RLM L3 video tasks for demo
- [ ] Record Ralphy execution with OBS
- [ ] Extract stills, write narration
- [ ] Build narrated demo clip

### Phase 4: Avatar Clips (Requires TTS)
- [ ] Build 01-hook avatar clip
- [ ] Build 14-cta avatar clip

### Phase 5: Assembly
- [ ] Build all SVG clips
- [ ] Concatenate final video
- [ ] Audio normalization check

## Key Scripts (from rlm-wasm pattern)

| Script | Purpose |
|--------|---------|
| `common.sh` | Paths and tool locations |
| `generate-tts.sh` | Text -> TTS audio |
| `build-title.sh` | Image + music -> title clip |
| `build-svg-clip.sh` | SVG + audio -> video clip |
| `build-avatar-clip.sh` | Avatar + lipsync |
| `build-final.sh` | Normalize + concatenate |

## Tools Used

- **vid-tts**: TTS generation via VibeVoice
- **vid-image**: Image -> video with effects
- **vid-avatar**: Avatar clip extraction
- **vid-lipsync**: MuseTalk lip sync
- **vid-concat**: Video concatenation
- **vid-volume**: Audio level check
- **rsvg-convert**: SVG -> PNG
- **ffmpeg**: Low-level video operations

## TTS Guidelines

Per docs/tts-narration-guidelines.md:
- Max 240 chars per script
- Spell acronyms: "Ralphy" is fine, but "CLI" -> "C L I"
- Numbers spelled out: "60" -> "sixty"
- Only periods and commas
- Verify with whisper-cli

## File Structure

```
projects/ralphy/
├── assets/
│   ├── images/
│   │   └── teacher-yells-ralphy.jpg  # Title image
│   ├── svg/                          # Architecture diagrams
│   └── videos/                       # Raw recordings
├── docs/
│   ├── project-brief.md
│   └── plan.md                       # This file
├── scripts/
│   ├── common.sh
│   ├── build-title.sh
│   └── ...
└── work/
    ├── audio/                        # TTS output
    ├── clips/                        # Built clips
    │   └── 00-title.mp4             # Title (done)
    ├── preview/
    │   └── index.html               # Live preview
    ├── scripts/                      # Narration text
    └── vhs/                          # Demo recordings
```

## One Step at a Time

User preference: Build incrementally, one step at a time.

Current status:
- [x] Title clip built (5s)
- [x] Preview page created
- [ ] Next: Create SVG diagrams or write narration scripts
