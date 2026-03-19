#!/bin/bash
# Build 99x-outro.mp4: Last frame from epilog + music fade-out
# Source: work/stills/99-outro-frame.png + assets/rc-v2-blues-shuffle_*.wav
# Music: 2-9s (7s total), 3s fade-out starting at 4s
set -euo pipefail
cd "$(dirname "$0")/.."

MUSIC=$(ls assets/rc-v2-blues-shuffle_*.wav)

# Extract last frame from subscribe reminder if not present
if [ ! -f work/stills/99-outro-frame.png ]; then
  ffmpeg -y -sseof -0.1 -i work/clips/99-subscribe-reminder.mp4 \
    -vframes 1 work/stills/99-outro-frame.png
fi

ffmpeg -y -loop 1 -i work/stills/99-outro-frame.png \
  -i "$MUSIC" \
  -filter_complex "[1:a]atrim=2:9,asetpts=PTS-STARTPTS,afade=t=out:st=4:d=3[a]" \
  -map 0:v -map "[a]" \
  -c:v libx264 -tune stillimage -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  -t 7 -r 30 \
  work/clips/99x-outro.mp4

./scripts/normalize-volume.sh work/clips/99x-outro.mp4
echo "Built: work/clips/99x-outro.mp4"
