# RLM CLI Video Production Plan

## Video Structure

| Segment | Duration | Type | Description |
|---------|----------|------|-------------|
| 00-title | 5s | Title card | Title image with music |
| 01-hook | ~15s | Avatar | Hook about native execution |
| 02-intro | ~15s | SVG | L3 overview diagram |
| 03-demo-cli | ~60s | VHS | L3 script execution demos |
| 04-intro-viz | ~15s | SVG | Visualizer introduction |
| 05-demo-viz | ~60s | OBS | Visualizer demo recordings |
| 06-comparison | ~15s | SVG | L1 vs L2 vs L3 comparison |
| 99-cta | ~15s | Avatar | Call to action |
| 99b-epilog | ~13s | Standard | Epilog with music |

**Total: ~210s (~3:30)**

## Segments Detail

### 00-title - Title Card
- Image: assets/images/rlm-cli.jpg (user to provide)
- Music: TBD
- Duration: 5s

### 01-hook - Hook with Avatar
- SVG background: assets/svg/01-hook.svg
- Narration: work/scripts/01-hook.txt
- Avatar: lip-synced overlay

### 02-intro - L3 Overview
- SVG: assets/svg/02-intro.svg
- Narration: work/scripts/02-intro.txt
- Show L3 in context of execution levels

### 03-demo-cli - L3 Script Demos
- Source: ../rlm-project L3 demos
- Recording: VHS tape file
- Narration: overlay or segment clips

### 04-intro-viz - Visualizer Intro
- SVG: assets/svg/04-intro-viz.svg
- Narration: work/scripts/04-intro-viz.txt

### 05-demo-viz - Visualizer Demos
- Source: ../rlm-project visualizer
- Recording: OBS (GUI capture required)
- Narration: overlay or segment clips

### 06-comparison - Level Comparison
- SVG: assets/svg/06-comparison.svg
- Narration: work/scripts/06-comparison.txt
- L1 (DSL) vs L2 (WASM) vs L3 (Native)

### 99-cta - Call to Action
- SVG: assets/svg/99-cta.svg
- Narration: work/scripts/99-cta.txt
- Avatar: lip-synced overlay
- Links: RLM project repo

### 99b-epilog - Standard Epilog
- Source: ../video-publishing/reference/epilog/99b-epilog.mp4
- Extension: 5s music fade

## TTS Guidelines

Per docs/tts-narration-guidelines.md:
- Max 240 chars per script
- Only periods and commas
- Verify with whisper-cli:
  ```bash
  ffmpeg -y -i clip.mp4 -ar 16000 -ac 1 -c:a pcm_s16le /tmp/audio.wav
  whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/audio.wav -nt
  ```

## File Structure

```
projects/rlm-cli/
├── assets/
│   ├── images/
│   │   └── rlm-cli.jpg        # Title image (user to add)
│   ├── svg/                    # Slide graphics
│   └── videos/                 # OBS recordings
├── docs/
│   ├── project-brief.md
│   └── plan.md                 # This file
├── scripts/
│   └── ...                     # Build scripts
└── work/
    ├── audio/                  # TTS output
    ├── clips/                  # Built clips
    ├── scripts/                # Narration text
    ├── stills/                 # PNG renders
    └── preview/                # Preview HTML
```

## Production Workflow

1. [ ] User adds title image
2. [ ] Create SVG slides (28px+ fonts)
3. [ ] Write narration scripts
4. [ ] Record L3 demos with VHS
5. [ ] Record visualizer demos with OBS
6. [ ] Generate TTS audio
7. [ ] Build avatar clips (hook, CTA)
8. [ ] Composite and assemble
9. [ ] Verify with whisper
10. [ ] Final concatenation
