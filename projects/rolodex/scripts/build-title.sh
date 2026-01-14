#!/bin/bash
# Build title clip: image + music
# Usage: ./build-title.sh

set -e
source "$(dirname "$0")/common.sh"

# Inputs
TITLE_IMAGE="$ASSETS/images/rolodex.jpg"
# MUSIC is defined in common.sh

# Output
OUTPUT="$CLIPS/00-title.mp4"

# Duration (typically 4-5 seconds)
DURATION=5

echo "=== Building Title Clip ==="
echo "Image: $TITLE_IMAGE"
echo "Music: $MUSIC"
echo "Duration: ${DURATION}s"
echo "Output: $OUTPUT"
echo ""

# Check inputs
if [ ! -f "$TITLE_IMAGE" ]; then
    echo "Error: Image not found: $TITLE_IMAGE"
    exit 1
fi
if [ ! -f "$MUSIC" ]; then
    echo "Error: Music not found: $MUSIC"
    exit 1
fi

mkdir -p "$CLIPS"

# Step 1: Create video from image with ken-burns effect
echo "Step 1: Creating ${DURATION}s video clip..."
$VID_IMAGE \
    --image "$TITLE_IMAGE" \
    --output "/tmp/title-silent-$$.mp4" \
    --duration "$DURATION" \
    --effect ken-burns

# Step 2: Add music
echo "Step 2: Adding music..."
# Volume 0.23 brings music to ~-25 dB (matching reference)
ffmpeg -y -i "/tmp/title-silent-$$.mp4" -i "$MUSIC" \
    -filter_complex "[1:a]volume=0.23,atrim=0:${DURATION},asetpts=PTS-STARTPTS[a]" \
    -map 0:v -map "[a]" \
    -c:v copy -c:a aac -ar 44100 -ac 2 \
    -shortest "$OUTPUT" 2>/dev/null

rm -f "/tmp/title-silent-$$.mp4"

# Verify
echo ""
echo "=== Result ==="
echo "Output: $OUTPUT"
ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT" | xargs printf "Duration: %.2fs\n"
