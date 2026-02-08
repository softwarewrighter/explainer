# Pipeline-rs - Video Project

## Overview

An explainer video about recreating IBM mainframe TSO Pipelines in Rust. A Throwback Thursday project demonstrating record-oriented dataflow processing with a CLI tool, web-based tutorial, and interactive debugger.

## Historical Context

- **Year**: 1996
- **Event**: IBM hosted the 1996 Olympics Web Server (probably the largest at the time)
- **Infrastructure**: Many systems serving dynamic web pages, logs funneled to a pair of IBM S/390 mainframes
- **OS**: OS/390 (formerly MVS)
- **Tool**: TSO Pipelines (the MVS/ESA port of CMS Pipelines from VM/ESA)
- **Use**: Ad hoc log analysis for statistics and forensics

## Project Details

- **Source**: ~/github/sw-comp-history/pipeline-rs
- **Language**: Rust with WASM web UI (Yew framework)
- **Live demo**: https://sw-comp-history.github.io/pipelines-rs/
- **Records**: 80-byte fixed-width (punch card format)
- **Implementations**:
  - **Batched**: Processes all records through each stage (faster, but not true dataflow)
  - **RAT** (Record At a Time): Moves each record through full pipeline (true dataflow concept)
  - Both are O(N); Batched is faster; future version planned with fewer buffers/copies

## Supported Stages

FILTER, SELECT, TAKE, SKIP, LOCATE, NLOCATE, CHANGE, COUNT, UPPER, LOWER, REVERSE, DUPLICATE, LITERAL, HOLE, CONSOLE

## Video Structure

| # | Segment | Duration | Type | Content |
|---|---------|----------|------|---------|
| 00 | Title | 5s | Image + music | Title card (TBD) |
| 01 | Hook | ~15s | SVG + avatar (curmudgeon) | Olympics web server, mainframe log analysis |
| 02 | Context | ~15s | SVG | CMS/TSO Pipelines history, record-oriented dataflow |
| 03 | Concept | ~15s | SVG | Pipeline stages, 80-byte records, dataflow model |
| 04 | CLI Demo | ~20s | Screen recording | Running pipeline specs from CLI |
| 05 | Web UI | ~20s | Screen recording | Web UI editor/runner with tutorials |
| 06 | Debugger | ~20s | Screen recording | RAT debugger with stepping/watches/breakpoints |
| 07 | Architecture | ~15s | SVG | Batched vs RAT |
| 08 | Future | ~15s | SVG | In-place buffers, multi-pipe routing |
| 99 | CTA | ~15s | SVG + avatar (curmudgeon) | Try it yourself, links |
| 99b | Epilog | ~13s | Shared clip (narrated) | Like and subscribe (same clip as all explainers) |
| 99c | Epilog Ext | 10s | Music | Epilog frame + "Bad Beat" music fade out over last 3s |

## Audio

- **Title (00)**: "Bad Beat" by Dyalla (5 seconds)
- **Epilog Extension (99c)**: Same music, 10 seconds, fade out over last 3s
- **Music file**: `assets/music/Bad Beat - Dyalla.mp3`
- **Voice**: VoxCPM voice cloning with mike-medium-ref-1.wav (63s reference)

## Key Messages

1. TSO Pipelines was a powerful mainframe tool for record-oriented data processing
2. The concept maps well to modern Rust with iterators and WASM
3. The web UI with tutorials makes mainframe concepts accessible
4. The RAT debugger visualizes dataflow at the record level
5. Two implementations show different tradeoffs (speed vs conceptual clarity)

## Narration Notes

- Use "T S O" not "TSO" for TTS pronunciation
- Use "C M S" not "CMS"
- Use "R A T" not "RAT"
- Use "I B M" not "IBM"
- Use "O S three ninety" not "OS/390"
- Use "M V S" not "MVS"
- Use "V M" not "VM"
- Use "Web Assembly" not "WASM"
- Numbers spelled out: "nineteen ninety six", "eighty"
- Blog post will cover deeper technical details

## Production Steps

1. [x] Create directory structure
2. [x] Create plan.md (this file)
3. [x] Write narration scripts
4. [ ] Create SVG slides following style guide
5. [ ] Record screen demos (CLI, Web UI, Debugger)
6. [ ] Generate TTS audio (VoxCPM)
7. [ ] Create video clips
8. [ ] Avatar lip-sync for hook and CTA
9. [ ] Add title image and music (user will provide)
10. [ ] Create title clip
11. [ ] Normalize all audio
12. [ ] Concatenate final video

## Project Paths

```
pipeline-rs/
├── assets/
│   ├── svg/           # SVG slides
│   ├── images/        # Title image (TBD)
│   └── music/         # Music track (TBD)
├── docs/
│   └── plan.md        # This file
├── scripts/
│   └── normalize-volume.sh
├── tts/
│   ├── client.py      # VoxCPM TTS client
│   └── .venv/         # Python venv (uv)
├── work/
│   ├── scripts/       # Narration scripts
│   ├── audio/         # TTS output
│   ├── clips/         # Final video clips
│   ├── stills/        # PNG renders
│   ├── avatar/        # Lipsync files
│   ├── vhs/           # VHS recordings
│   ├── reference/     # TTS reference audio
│   ├── preview/       # Preview with symlinks
│   │   ├── index.html
│   │   ├── clips -> ../clips
│   │   ├── audio -> ../audio
│   │   ├── stills -> ../stills
│   │   ├── images -> ../../assets/images
│   │   └── svg -> ../../assets/svg
│   ├── description.txt
│   └── generate-tts.sh
```

## Waiting On

- [x] Title image: `assets/images/tbt-pipelines-os-390.jpg`
- [x] Music: `assets/music/Bad Beat - Dyalla.mp3`
- [ ] Screen recordings: CLI demo, Web UI, Debugger
