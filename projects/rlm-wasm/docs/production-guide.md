# RLM WASM Video Production Guide

## Overview

**Topic**: RLM WASM feature - LLM delegating complex analysis to generated Rust/WASM code
**Duration Target**: ~2-3 minutes
**Music**: All In - Everet Almond
**Avatar**: curmudgeon.mp4

## CRITICAL: Format Requirements

All clips MUST match these specifications before concatenation:

| Property | Required Value | Check Command |
|----------|----------------|---------------|
| Resolution | 1920x1080 | `ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0` |
| Audio Sample Rate | 44100 Hz | `ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of csv=p=0` |
| Audio Channels | 2 (stereo) | `ffprobe -v error -select_streams a:0 -show_entries stream=channels -of csv=p=0` |
| Audio Codec | AAC | `ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of csv=p=0` |

**WARNING**: Mixed audio formats cause SILENT audio after concatenation. This is a recurring bug that has wasted many hours. ALWAYS normalize before concat.

## Clip Inventory

| Clip | Duration | Type | Description |
|------|----------|------|-------------|
| 00-title.mp4 | 5s | Title | Book image + Ken Burns + music |
| 01-hook-composited.mp4 | ~12s | Avatar | Hook with lip-synced avatar |
| 02-demo.mp4 | 45s | CLI | VHS recording of RLM WASM demo |
| 14-cta-composited.mp4 | ~10s | Avatar | CTA with lip-synced avatar |
| 99b-epilog.mp4 | ~12s | Epilog | Like & Subscribe (from reference) |
| 99c-epilog-ext.mp4 | 5s | Epilog | Final frame + project music |

## Avatar Build Workflow

**CRITICAL**: Run avatar builds on DIFFERENT hive servers to avoid CUDA OOM:

```bash
# Terminal 1 - hook on hive:3015
./scripts/build-avatar-clip.sh 01-hook hive:3015

# Terminal 2 - CTA on hive:3016 (PARALLEL)
./scripts/build-avatar-clip.sh 14-cta hive:3016
```

**NEVER run two MuseTalk jobs on the same server!**

### Avatar Build Steps

1. SVG to PNG: `rsvg-convert -w 1920 -h 1080 input.svg -o output.png`
2. Create base clip: `vid-image --image png --audio wav --effect ken-burns`
3. Stretch avatar: `vid-avatar --avatar source.mp4 --duration N --output stretched.mp4`
4. Lip-sync: `vid-lipsync --avatar stretched.mp4 --audio wav --server hive:PORT --output lipsynced.mp4`
5. Composite: `vid-composite --content base.mp4 --avatar lipsynced.mp4 --output final.mp4`
6. Normalize: `./scripts/normalize-volume.sh final.mp4 -25`

## Tool Reference

| Tool | Purpose | Key Flags |
|------|---------|-----------|
| vid-tts | Generate TTS audio | --script, --output, --print-duration |
| vid-image | Image to video | --image, --audio, --duration, --effect |
| vid-avatar | Stretch avatar | --avatar, --duration, --fps, --output |
| vid-lipsync | Lip-sync | --avatar, --audio, --server, --output |
| vid-composite | Overlay avatar | --content, --avatar, --output |
| vid-concat | Join clips | --list, --output, --reencode |
| vid-volume | Audio levels | --input, --db, --print-levels |
| vid-music | Add music | --input, --music, --fade-in, --fade-out |

## Troubleshooting

### Audio Disappears After Concat

1. Check all clips are 44100 Hz stereo
2. Use `build-final.sh` which normalizes automatically
3. Use `--reencode` flag with vid-concat

### CUDA Out of Memory

Never run two MuseTalk jobs on the same hive server. Use different ports:
- hive:3015
- hive:3016
