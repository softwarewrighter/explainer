# RLM CLI Explainer Video

## Overview
RLM CLI demonstrates Level 3 (L3) native execution - running Rust CLI tools directly without sandboxing. This is the final level of the RLM execution hierarchy.

## Subject
The ../rlm-project L3 demos:
- L3 demo scripts showing native CLI execution
- Visualizer demos (to be recorded via OBS)

## Video Focus
- Native Rust CLI execution (no WASM sandbox)
- Performance benefits of native code
- Visualizer tool demonstrations
- When to use L3 vs L1/L2

## Key Messages
- L3 is for trusted, performance-critical code
- Native execution removes sandbox overhead
- Visualizer shows RLM execution flow
- Complete the L1 → L2 → L3 progression

## Assets Needed
- [ ] Title image (user will add)
- [ ] L3 architecture diagram
- [ ] Demo recordings (OBS for visualizer)
- [ ] Comparison chart (L1 vs L2 vs L3)

## Duration Target
~3:30 (similar to other explainer videos)

## SVG Design Requirements

All SVG slides must follow the font size guidelines in `/docs/svg-design-guidelines.md`.

### Minimum Font Sizes
- **All text: 28px minimum** (never smaller)
- Body text: 28-32px
- Monospace/URLs: 28-32px
- Headlines: 84-96px
- Stroke widths: 4-5px for visibility

## Recording Notes

### VHS Recordings (terminal demos)
- L3 script execution demos
- Can be automated with VHS tape files
- **Environment variables**: Use this pattern to load env vars in VHS:
  ```
  Type "export $(cat ~/.env | grep -v '^#' | xargs) && ./your-script.sh"
  ```
  This reliably exports variables from `~/.env` (e.g., `LITELLM_MASTER_KEY`) for LiteLLM API access.
  Note: `source ~/.env` does not work reliably in VHS recordings.

### OBS Recordings (visualizer)
- Visualizer requires OBS for GUI capture
- Record at 1920x1080, 30fps
- Trim and process with ffmpeg

## Current Progress

**Completed segments (3:00 total):**
- 00-title: Title card with music (5s)
- 01-hook: Hook with lipsynced curmudgeon avatar (14.7s)
- 01b-paper-intro: RLM paper abstract with Ken Burns (15.5s)
- 02-intro-l3: L3 overview SVG slide (19.9s)
- 03a-c: Error ranking demo - 3 narrated clips (33s)
- 04-intro-percentiles: Percentiles demo intro SVG (19.3s)
- 05a-c: Percentiles demo - 3 narrated clips (38s)
- 99-cta: CTA with lipsynced avatar and GitHub link (16.5s)
- 99b-epilog: Standard epilog (12.8s)
- 99c-epilog-ext: Music outro (5s)

**Pending:**
- 06-intro-viz: Visualizer intro SVG
- 07-demo-viz: Visualizer OBS recording
- 08-comparison: L1 vs L2 vs L3 comparison SVG

## Lessons Learned

### Audio Format Normalization (CRITICAL)
All clips MUST be 44100Hz stereo before concatenation. TTS generates 24000Hz mono, which breaks concat.

**Always run normalize-volume.sh on every clip:**
```bash
./scripts/normalize-volume.sh work/clips/02-intro-l3.mp4
# Output: "02-intro-l3.mp4  FORMAT FIXED: 24000 Hz 1 ch -> 44100 Hz stereo"
```

### Proper Concatenation
Use `vid-concat` with absolute paths, NOT raw ffmpeg:
```bash
# Create concat-list.txt with absolute paths (no "file '...'" prefix)
$VID_CONCAT --list clips/concat-list.txt --output preview.mp4 --reencode
```

### Whisper Verification
Always verify TTS audio before final assembly:
```bash
ffmpeg -y -i preview.mp4 -ar 16000 -ac 1 -c:a pcm_s16le /tmp/audio.wav
whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/audio.wav -nt
```
