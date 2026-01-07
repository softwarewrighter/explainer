#!/bin/bash
# Build title clip with background music
# Usage: ./build-title.sh

set -e
source "$(dirname "$0")/common.sh"

TITLE_IMAGE="$ASSETS/images/title.jpg"
OUTPUT="$CLIPS/01-title.mp4"
DURATION=4.0
VOLUME=0.6
MUSIC_OFFSET=15

if [ ! -f "$TITLE_IMAGE" ]; then
    echo "Error: Title image not found: $TITLE_IMAGE"
    exit 1
fi

echo "=== Building title clip ==="
echo "Image: $TITLE_IMAGE"
echo "Duration: ${DURATION}s"
echo "Music: $MUSIC (offset ${MUSIC_OFFSET}s, volume ${VOLUME})"

$VID_IMAGE \
    --image "$TITLE_IMAGE" \
    --output "$OUTPUT" \
    --duration "$DURATION" \
    --music "$MUSIC" \
    --music-offset "$MUSIC_OFFSET" \
    --volume "$VOLUME"

echo "Created: $OUTPUT"
$VID_VOLUME --input "$OUTPUT" --print-levels

# Check if volume is adequate (mean should be > -40 dB)
MEAN=$($VID_VOLUME --input "$OUTPUT" --print-levels 2>&1 | grep "Mean volume" | awk '{print $3}')
echo "Mean volume: $MEAN"
echo ""
echo "If mean is below -35 dB, consider boosting with:"
echo "  ./boost-volume.sh 01-title.mp4 15 01-title-boosted.mp4"
