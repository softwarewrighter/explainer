# Favicon Production Troubleshooting Guide

Lessons learned during favicon video production.

---

## Lip-Sync Timing Issues

### Problem: Lips Moving Too Fast

**Symptom**: Lip-synced avatar has lips moving faster than the audio narration.

**Root Cause**: Overriding the default fps in vid-avatar and/or vid-lipsync.

**What Went Wrong**:
The source avatar (lion-actor.mp4) is 24fps. An AI agent incorrectly assumed it should preserve this frame rate by adding `--fps 24` to both vid-avatar and vid-lipsync calls:

```bash
# WRONG - Do not override fps
$VID_AVATAR \
    --avatar "$AVATAR_SOURCE" \
    --duration "$DURATION" \
    --output "$STRETCHED" \
    --fps 24              # <-- WRONG: causes timing mismatch

$VID_LIPSYNC \
    --avatar "$STRETCHED" \
    --audio "$AUDIO_FILE" \
    --output "$LIPSYNCED" \
    --fps 24              # <-- WRONG: causes timing mismatch
```

**Why This Breaks**: The video pipeline is designed to work at 30fps throughout:
- vid-avatar stretches video to 30fps by default
- MuseTalk generates frames expecting 30fps assembly
- vid-lipsync assembles at 30fps by default

Forcing 24fps causes a mismatch where MuseTalk's frames are assembled at the wrong rate.

**Correct Usage**:
```bash
# CORRECT - Use defaults (30fps)
$VID_AVATAR \
    --avatar "$AVATAR_SOURCE" \
    --duration "$DURATION" \
    --output "$STRETCHED"

$VID_LIPSYNC \
    --avatar "$STRETCHED" \
    --audio "$AUDIO_FILE" \
    --output "$LIPSYNCED"
```

**Prevention**:
1. **Never override fps** unless you have a specific, documented reason
2. **Trust the defaults** - the Rust tools are designed with correct defaults
3. **Compare with working projects** - when something breaks, diff against babyai-hrm or other working projects
4. **Don't assume source fps matters** - the tools handle frame rate conversion internally

---

## General Debugging Approach

When a clip doesn't work correctly:

1. **Compare with working project**:
   ```bash
   diff projects/babyai-hrm/scripts/build-avatar-clip.sh \
        projects/favicon/scripts/build-avatar-clip.sh
   ```

2. **Check what parameters differ** - any "extra" parameters you added are suspects

3. **Remove customizations** - start with the exact same command as the working project

4. **Add customizations one at a time** - test after each change

---

## Tool Reference

| Tool | Default FPS | Notes |
|------|-------------|-------|
| vid-avatar | 30 | Do not override |
| vid-lipsync | 30 | Do not override |
| vid-image | 30 | Do not override |
| vid-composite | N/A | Uses input fps |
| vid-concat | N/A | Uses input fps |
