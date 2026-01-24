# Engram POC Video Project

## Overview

A proof of concept video demonstrating an Engram-inspired persistent memory cache for LLMs. Inspired by DeepSeek's Engram research paper and implementation.

## Concept

Engram provides persistent memory for Language Models by:
- Caching past interactions indexed by topic
- Automatically recalling relevant memories when related questions arise
- Enabling context to persist across conversation boundaries

## Video Structure (Draft)

| # | Segment | Duration | Type | Content |
|---|---------|----------|------|---------|
| 00 | Title | 5s | Image + music | Title card |
| 01 | Hook | ~15s | SVG + avatar | The problem: LLMs forget between sessions |
| 02 | Intro | ~15s | SVG | What is Engram, DeepSeek inspiration |
| 03+ | Demo | TBD | VHS | Engram demo segments |
| 99 | CTA | ~15s | SVG + avatar | Try it yourself, links |
| 99b | Epilog | ~12s | Standard | Like and subscribe |
| 99c | Epilog Ext | 12s | Image + music | Music fade out |

## Assets Needed

- [ ] Title image → `assets/images/`
- [ ] Music track → `assets/music/`
- [ ] Demo implementation
- [ ] Demo scripts for VHS recording

## Project Paths

```
engram-poc/
├── assets/
│   ├── svg/           # SVG slides
│   ├── images/        # Title image (ADD HERE)
│   └── music/         # Music track (ADD HERE)
├── docs/
│   └── plan.md        # This file
├── scripts/
│   └── normalize-volume.sh
├── work/
│   ├── scripts/       # Narration scripts
│   ├── audio/         # TTS output
│   ├── clips/         # Final video clips
│   ├── stills/        # PNG renders
│   ├── avatar/        # Lipsync files
│   ├── vhs/           # VHS recordings
│   ├── obs/           # OBS recordings
│   └── preview/       # Preview with symlinks
│       ├── index.html
│       ├── clips -> ../clips
│       ├── audio -> ../audio
│       ├── stills -> ../stills
│       ├── images -> ../../assets/images
│       └── svg -> ../../assets/svg
```

## Next Steps

1. Add title image to `assets/images/`
2. Select music and add to `assets/music/`
3. Create title clip (00-title.mp4)
4. Copy epilog (99b-epilog.mp4)
5. Create epilog extension (99c-epilog-ext.mp4)
6. Develop hook and CTA narration
7. Record demos when implementation is ready
