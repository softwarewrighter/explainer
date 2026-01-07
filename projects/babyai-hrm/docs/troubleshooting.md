# Production Troubleshooting Guide

Lessons learned during babyai-hrm video production.

---

## Audio Volume Issues

### Problem: Title/Epilog Music Too Quiet

**Symptom**: Draft video starts silent or nearly silent. Music from title/epilog clips is inaudible.

**Root Cause**: Using `--volume 0.3` with `vid-image` for background music results in mean volume around -56 dB, which is effectively silent.

**Diagnosis**:
```bash
vid-volume --input work/clips/01-title.mp4 --print-levels
# If mean_volume is below -40 dB, audio is too quiet
```

**Fix**:
```bash
# Boost the clip by 15 dB
vid-volume --input work/clips/01-title.mp4 \
  --output work/clips/01-title-boosted.mp4 \
  --db 15
```

**Prevention**: When creating clips with background music:
- Use `--volume 0.5` minimum for background music (0.6-0.8 preferred)
- Always verify audio levels after creation with `vid-volume --print-levels`
- Target mean volume: -24 to -28 dB for audible audio

### Problem: Narration Volume Too Low

**Symptom**: Voiceover is audible but too quiet relative to other clips.

**Diagnosis**:
```bash
vid-volume --input work/clips/24b-demo.mp4 --print-levels
# Compare mean_volume across clips - they should be similar
```

**Fix**:
```bash
# Boost narration by 10 dB
vid-volume --input work/clips/24b-demo.mp4 \
  --output work/clips/24b-demo-boosted.mp4 \
  --db 10
```

**Target Levels**:
| Content Type | Target Mean Volume |
|--------------|-------------------|
| Speech/narration | -24 to -28 dB |
| Background music | -30 to -35 dB |
| Mixed audio | -26 to -30 dB |

---

## Resolution Mismatch Issues

### Problem: vid-concat Fails with Different Resolutions

**Symptom**: Error "Input link parameters do not match output link" when concatenating clips.

**Root Cause**: Clips have different resolutions (e.g., 1660x1080 from OBS vs 1920x1080 standard).

**Diagnosis**:
```bash
ffprobe -v error -select_streams v:0 \
  -show_entries stream=width,height \
  -of csv=p=0 work/clips/problem-clip.mp4
```

**Fix**:
```bash
# Scale/pad to standard 1920x1080
vid-scale --input work/clips/problem-clip.mp4 \
  --output work/clips/problem-clip-scaled.mp4 \
  --width 1920 --height 1080 \
  --pad
```

**Prevention**:
- Check resolution of any externally-sourced clips before adding to concat list
- Use `vid-scale --pad` for non-standard aspect ratios (adds letterboxing)
- Use `vid-scale --stretch` only when aspect ratio matches

---

## Audio Format Mismatch Issues

### Problem: Silent Audio After Concatenation

**Symptom**: Some clips have audio in isolation but are silent in concatenated output.

**Root Cause**: Clips have different audio formats (e.g., 44100Hz stereo vs 24000Hz mono).

**Diagnosis**:
```bash
ffprobe -v error -select_streams a:0 \
  -show_entries stream=sample_rate,channels \
  -of csv=p=0 work/clips/*.mp4
```

**Fix**: Use `vid-concat --reencode` which normalizes all audio to consistent format.

```bash
vid-concat --list work/clips/concat-list.txt \
  --output work/draft.mp4 \
  --reencode
```

**Prevention**: Always use `--reencode` flag when concatenating clips from different sources.

---

## Quick Reference: Audio Level Workflow

Before concatenating any draft video:

```bash
# 1. Check all clip levels
for clip in work/clips/*.mp4; do
  echo "=== $clip ==="
  vid-volume --input "$clip" --print-levels 2>&1 | grep -E "mean|max"
done

# 2. Boost any clips with mean below -35 dB
vid-volume --input quiet-clip.mp4 --output boosted-clip.mp4 --db 10

# 3. Update concat-list.txt to use boosted versions

# 4. Concatenate with reencode
vid-concat --list work/clips/concat-list.txt \
  --output work/draft.mp4 \
  --reencode

# 5. Verify final audio
vid-volume --input work/draft.mp4 --print-levels
```

---

## Tool Reference

| Tool | Purpose | Key Flags |
|------|---------|-----------|
| `vid-volume` | Check/adjust audio levels | `--print-levels`, `--db N`, `--gain N` |
| `vid-scale` | Resize/pad video | `--width`, `--height`, `--pad`, `--crop` |
| `vid-concat` | Join clips | `--list`, `--reencode` |
| `vid-image` | Create clip from image | `--volume N` (0.0-1.0 for music) |
