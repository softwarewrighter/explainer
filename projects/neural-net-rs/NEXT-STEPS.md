# Neural-Net-RS Project Status

**Last Updated:** 2026-02-15 - preview-complete.mp4 FINISHED (6:48)

## Video Complete

The full preview video is ready for review:
- **Output:** `work/preview-complete.mp4`
- **Duration:** 408 seconds (~6 minutes 48 seconds)
- **Resolution:** 1920x1080
- **Audio:** 44100Hz stereo, normalized to -25dB

## Video Structure (21 segments)

| # | Segment | Type | Duration | Description |
|---|---------|------|----------|-------------|
| 1 | 00-title | Music | 7s | Gold title with music |
| 2 | 01-hook | Narration | 17s | Introduction |
| 3 | 02-overview | Narration | 15s | Project overview |
| 4 | 03-logic-gates | Narration | 19s | Logic gate examples |
| 5 | 04-scaling | Narration | 15s | Scaling neural networks |
| 6 | 05-multiclass | Narration | 18s | Multiclass classification |
| 7 | 06-arithmetic | Narration | 18s | Arithmetic operations |
| 8 | 07-iris | Narration | 16s | Iris dataset |
| 9 | 08-patterns | Narration | 17s | Pattern recognition |
| 10 | 09-cli-intro | Narration | 14s | CLI introduction |
| 11 | 10-cli-demo | Narration | 57s | VHS CLI demo with extended narration |
| 12 | 11-webui-intro | Narration | 16s | Web UI introduction |
| 13 | 12-and-demo | Narration | 17s | AND gate demo |
| 14 | 13-or-demo | Narration | 17s | OR gate demo |
| 15 | 14-xor-intro | Narration | 18s | XOR challenge intro |
| 16 | 15-xor-demo | Narration | 31s | XOR demo with parameter tuning (full video) |
| 17 | 16-parity3-intro | Narration | 18s | PARITY3 introduction |
| 18 | 17-parity3-demo | Narration | 45s | PARITY3 demo (3 training attempts, full video) |
| 19 | 99-cta | Narration | 13s | Call to action |
| 20 | 99b-epilog | Narration | 7s | Epilog with narration |
| 21 | 99c-epilog-ext | Music | 7s | Music fade out extension |

## Build Issues Fixed

### Issue 1: Silent Audio on Slides (-91 dB)
**Problem:** Slides 01-09, 11, 14, 16, 99 had -91dB audio (essentially silent)
**Cause:** Two-step ffmpeg audio combination failed to include audio
**Fix:** Use `vid-image --audio` directly, or use explicit `-map 0:v -map 1:a` in ffmpeg

### Issue 2: Title Card Wrong Dimensions (2066x962)
**Problem:** Title background was 2066x962, causing concat to fail
**Cause:** Source image not scaled to 1920x1080
**Fix:** Scale with ffmpeg before creating video:
```bash
ffmpeg -y -i input.png -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" output.png
```

### Issue 3: Audio Format Mismatch
**Problem:** Some clips were 48000Hz, others 44100Hz
**Cause:** Different source files had different sample rates
**Fix:** Run `./scripts/normalize-volume.sh` on EVERY clip before concat

### Issue 4: OBS Clips Truncated
**Problem:** XOR and PARITY3 demos were truncated to match audio duration, cutting off important content (scrolling to show graphs)
**Cause:** Using `-shortest` flag or not extending audio to match video
**Fix:** NEVER truncate OBS/VHS recordings. Pad audio to match video duration:
```bash
ffmpeg -y -i source.mp4 -i audio.wav \
    -vf "scale=1920:1080:..." \
    -filter_complex "[1:a]apad=whole_dur=VIDEO_DUR[a]" \
    -map 0:v -map "[a]" output.mp4
```

### Issue 5: Run-on Narration
**Problem:** Abrupt jumps between segments with no pause
**Cause:** No silence padding at end of clips
**Fix:** Add 200ms silence to end of every narrated clip:
```bash
ffmpeg -y -i clip.mp4 -filter_complex "[0:a]apad=pad_dur=0.2[a]" \
    -map 0:v -map "[a]" -c:v copy -c:a aac output.mp4
```

## Key Files

### Final Output
- `work/preview-complete.mp4` - Complete video

### Concat List
- `work/preview/complete-concat.txt` - All 21 segments

### Music
- `/Users/mike/github/softwarewrighter/video-publishing/reference/music/When You're Not Looking - Nathan Moore.mp3`

### TTS Settings
Use `work/generate-tts.sh` for all TTS generation. It encapsulates the correct 63s reference file and prompt text.
