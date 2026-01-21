#!/bin/bash
# Build title clip: image + music
set -e
source "$(dirname "$0")/common.sh"

TITLE_IMAGE="$ASSETS/images/rlm-turtle-llms.jpg"
OUTPUT="$CLIPS/00-title.mp4"
DURATION=5

echo "=== Building Title Clip ==="
echo "Image: $TITLE_IMAGE"
echo "Music: $MUSIC"
echo "Duration: ${DURATION}s"

if [ ! -f "$TITLE_IMAGE" ]; then
    echo "Error: Image not found: $TITLE_IMAGE"
    exit 1
fi
if [ ! -f "$MUSIC" ]; then
    echo "Error: Music not found: $MUSIC"
    exit 1
fi

mkdir -p "$CLIPS"

# Create video with ken-burns
$VID_IMAGE \
    --image "$TITLE_IMAGE" \
    --output "/tmp/title-silent-$$.mp4" \
    --duration "$DURATION" \
    --effect ken-burns

# Add music (volume 0.23 = ~-25 dB)
ffmpeg -y -i "/tmp/title-silent-$$.mp4" -i "$MUSIC" \
    -filter_complex "[1:a]volume=0.23,atrim=0:${DURATION},asetpts=PTS-STARTPTS[a]" \
    -map 0:v -map "[a]" \
    -c:v copy -c:a aac -ar 44100 -ac 2 \
    -shortest "$OUTPUT" 2>/dev/null

rm -f "/tmp/title-silent-$$.mp4"

echo "Created: $OUTPUT"
ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT" | xargs printf "Duration: %.2fs\n"
