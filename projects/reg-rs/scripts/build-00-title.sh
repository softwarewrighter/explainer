#!/bin/bash
# Build 00-title.mp4: Background image + text overlay + music
# Source: assets/images/test-results.jpg + assets/rc-v2-blues-shuffle_*.wav
# Music: 0-5s, 4.5s full volume, 0.5s fade-out
set -euo pipefail
cd "$(dirname "$0")/.."

MUSIC=$(ls assets/rc-v2-blues-shuffle_*.wav)

ffmpeg -y \
  -loop 1 -i assets/images/test-results.jpg \
  -i "$MUSIC" \
  -filter_complex "\
    [0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,\
    eq=brightness=-0.25:contrast=0.75,\
    drawtext=text='\#TBT':fontsize=160:fontcolor=#d4af37:borderw=5:bordercolor=black:x=(w-text_w)/2:y=220:fontfile=/System/Library/Fonts/Supplemental/Arial\ Bold.ttf,\
    drawtext=text='CLI Regression Test Tool':fontsize=120:fontcolor=#ffd700:borderw=4:bordercolor=black:x=(w-text_w)/2:y=400:fontfile=/System/Library/Fonts/Supplemental/Arial\ Bold.ttf,\
    drawtext=text='reg-rs':fontsize=160:fontcolor=#d4af37:borderw=5:bordercolor=black:x=(w-text_w)/2:y=580:fontfile=/System/Library/Fonts/Supplemental/Arial\ Bold.ttf\
    [v];\
    [1:a]atrim=0:5,asetpts=PTS-STARTPTS,afade=t=out:st=4.5:d=0.5[a]" \
  -map "[v]" -map "[a]" \
  -c:v libx264 -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  -t 5 -r 30 \
  work/clips/00-title.mp4

./scripts/normalize-volume.sh work/clips/00-title.mp4
echo "Built: work/clips/00-title.mp4"
