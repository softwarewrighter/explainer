# Video Build Lessons Learned

## Common Issues and How to Avoid Them

### 1. Audio Sample Rate Mismatch - CRITICAL RECURRING BUG

**Problem**: Concatenating clips with different audio sample rates (24000 Hz vs 44100 Hz) or channel counts (mono vs stereo) causes audio dropouts or complete audio loss.

**ROOT CAUSE**: Reference epilog (99b-epilog.mp4) uses 24000 Hz MONO. TTS-generated audio uses 24000 Hz. Project clips use 44100 Hz STEREO. When these are concatenated without normalization, audio is SILENTLY DROPPED.

**Symptoms**:
- Silent audio in concatenated video
- Audio present at some timestamps but missing at others
- Last N seconds silent (epilog extension lost)
- Narration clips silent after concat

**MANDATORY FIX - DO THIS EVERY TIME**:

1. **IMMEDIATELY after copying/creating ANY clip**, normalize it:
```bash
ffmpeg -y -i input.mp4 -c:v copy -c:a aac -ar 44100 -ac 2 output.mp4
```

2. **In EVERY build script**, add normalization step:
```bash
# MANDATORY: Normalize audio format BEFORE any concat
ffmpeg -y -i "$CLIP" -c:v copy -c:a aac -ar 44100 -ac 2 "$CLIP.tmp" && mv "$CLIP.tmp" "$CLIP"
```

3. **ALWAYS verify audio format** before concat:
```bash
for f in *.mp4; do
    echo -n "$f: "
    ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate,channels -of csv=p=0 "$f"
done
# ALL must show: 44100,2
```

**Standard format**: 44100 Hz, stereo (2 channels), AAC codec

**Scripts that MUST normalize**:
- build-title.sh - after adding music
- build-avatar-clip.sh - after composite
- build-epilog.sh - BOTH base epilog AND extension BEFORE concat
- build-obs-aligned.sh - after building aligned clip
- normalize-volume.sh - should also enforce format

**THIS MISTAKE HAS BEEN MADE MULTIPLE TIMES. IT WASTES HOURS. ALWAYS NORMALIZE.**

### 2. Video Resolution Mismatch

**Problem**: Concatenating clips with different resolutions (e.g., 1660x1080 vs 1920x1080) causes ffmpeg concat filter to fail.

**Symptoms**:
- Error: "Input link parameters do not match output link parameters"
- Zero-byte output file

**Fix**: Scale all clips to same resolution:
```bash
ffmpeg -y -i input.mp4 \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
    -c:v libx264 -crf 18 -preset fast -c:a copy output.mp4
```

**Prevention**:
- Check resolution before concat: `ffprobe -v error -show_entries stream=width,height -of csv=p=0 file.mp4`
- Standard format: 1920x1080

### 3. Composited Avatar Audio Lost

**Problem**: vid-composite uses content clip audio, not avatar clip audio. If you re-composite with new base clip but existing avatar, the avatar's lip-synced audio may not be used.

**Symptoms**:
- Composited clip has silent or wrong audio
- Lip sync looks correct but audio doesn't match

**Fix**: Ensure the composited clip takes audio from the avatar (which has the lip-synced audio):
```bash
# vid-composite already handles this, but verify:
$VID_COMPOSITE --content base.mp4 --avatar lipsynced.mp4 --output out.mp4
```

**Prevention**:
- Don't rebuild avatar/lipsync if only the slide (SVG/PNG) changed
- Audio should flow: TTS -> lipsync -> composite
- If only visual changes, rebuild base clip, reuse existing lipsynced avatar

### 4. OBS Video/Audio Sync Drift

**Problem**: When building one long clip from many segments, timing errors accumulate and by the end, audio and video can be 30+ seconds out of sync.

**Symptoms**:
- Early segments are in sync
- Later segments show wrong content for narration
- At 10:18 showing CTA but narration is about previous topic

**Fix**: Build each narrated segment as independent clip, then concat:
```bash
# Per-segment approach:
for each segment:
    1. Extract video segment from OBS
    2. Add segment's audio
    3. Add 200ms silence gap
    4. Output as self-contained clip
# Then simple concat of all segment clips
```

**Prevention**:
- Don't build one monolithic aligned clip
- Each segment should be independently verifiable
- Modular approach allows fixing individual segments

### 5. SVG Bug Count Updates

**Problem**: When bug count changes (e.g., 5 -> 6), multiple SVGs and narrations need updating.

**Files to check**:
- 00-title.svg - main count (or use "many" to avoid updates)
- 02-hook.svg - RESULT line
- 68-cta.svg - bug checklist
- All narration scripts mentioning count

**Prevention**:
- Use generic language ("many bugs") in title to avoid count dependencies
- Keep a checklist of files mentioning bug count

## Checklist Before Concat

See global checklist: `../../docs/video-checklist.md`

1. [ ] All clips same resolution (1920x1080)
2. [ ] All clips same audio format (44100 Hz stereo)
3. [ ] All clips have audio track (not just video)
4. [ ] Verify audio levels: `scripts/check-levels.sh`
5. [ ] Use `--reencode` flag with vid-concat for safety
6. [ ] **EPILOG INCLUDED** - Don't forget 99-epilog-final.mp4!
7. [ ] Title and epilog use same music (soaring.mp3 for this project)
