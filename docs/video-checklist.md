# Video Production Checklist

Use this checklist before finalizing any video to ensure all parts are included and properly built.

## Pre-Build Checks

- [ ] All scripts exist in `work/scripts/*.txt`
- [ ] All TTS audio generated in `work/audio/*.wav`
- [ ] All SVGs exist in `assets/svg/`
- [ ] Common.sh defines correct MUSIC (project-specific)

## Required Clips (in order)

### 1. Title Clip (00-title-final.mp4)
- [ ] Script: `scripts/build-title.sh`
- [ ] Contains: Opening image + title slide + music
- [ ] Music: From `common.sh` MUSIC variable (soaring.mp3, etc.)
- [ ] Duration: ~7s (2s image + 5s slide)
- [ ] Volume normalized to -25 dB

### 2. Hook Clip (02-hook-final.mp4)
- [ ] Script: `scripts/build-avatar-clip.sh 02-hook`
- [ ] Contains: Hook slide + lip-synced avatar
- [ ] Has narration audio (not silent)
- [ ] Volume normalized to -25 dB

### 3. Main Content (OBS/Demo clips)
- [ ] Script: `scripts/build-obs-aligned.sh` (or similar)
- [ ] All segments included (check video-timeline)
- [ ] Audio/video in sync throughout
- [ ] Volume normalized to -25 dB

### 4. CTA Clip (68-cta-final.mp4 or similar)
- [ ] Script: `scripts/build-avatar-clip.sh 68-cta`
- [ ] Contains: CTA slide + lip-synced avatar
- [ ] Has narration audio (not silent)
- [ ] Volume normalized to -25 dB

### 5. Epilog (99-epilog-final.mp4)
- [ ] Script: `scripts/build-epilog.sh`
- [ ] Contains:
  - Reference epilog (99b-epilog.mp4) with lip-synced narration
  - Extension (99c-epilog-ext.mp4) with 5s freeze frame + project music
- [ ] Music: Same as title (from common.sh MUSIC)
- [ ] Volume normalized to -25 dB

## Concat List Verification

Run this to verify concat list includes all required clips:

```bash
# Expected clips (adjust numbers for your project):
# 00-title-final.mp4
# 02-hook-final.mp4
# 03-67-obs-1920.mp4 (or your OBS clip)
# 68-cta-final.mp4
# 99-epilog-final.mp4

cat work/clips/concat-v*.txt | tail -1  # Show latest concat list
```

## Audio Level Verification

```bash
# All clips should be ~-25 dB
scripts/check-levels.sh

# Or individually:
for clip in 00-title-final.mp4 02-hook-final.mp4 03-67-obs-1920.mp4 68-cta-final.mp4 99-epilog-final.mp4; do
    scripts/normalize-volume.sh "work/clips/$clip" -25
done
```

## Final Output Verification

```bash
# Check duration matches expected
ffprobe -v error -show_entries format=duration -of csv=p=0 work/clips/draft-vN.mp4

# Verify audio present at key points:
# - Start (title music)
# - Hook narration
# - Middle (OBS narration)
# - End (epilog narration + music)
ffplay -autoexit -t 10 work/clips/draft-vN.mp4  # Check first 10s
ffplay -autoexit -ss 600 -t 10 work/clips/draft-vN.mp4  # Check near end
```

## Common Mistakes to Avoid

1. **Missing epilog** - Always include 99-epilog-final.mp4
2. **Wrong music** - Title and epilog MUST use same music from common.sh
3. **Silent clips** - Check audio levels before concat
4. **Missing volume normalization** - All clips must be -25 dB
5. **Sync drift** - Test audio/video sync at multiple points

## Build Order

1. `scripts/generate-tts.sh` - Generate all TTS
2. `scripts/build-title.sh` - Build title with music
3. `scripts/build-avatar-clip.sh 02-hook` - Build hook
4. `scripts/build-obs-aligned.sh` - Build OBS content
5. `scripts/build-avatar-clip.sh 68-cta` - Build CTA
6. `scripts/build-epilog.sh` - Build epilog with music extension
7. `scripts/check-levels.sh` - Verify all levels
8. Update concat list to include ALL clips
9. Run vid-concat with --reencode
10. Verify final output
