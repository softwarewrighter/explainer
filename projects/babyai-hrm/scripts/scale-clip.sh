#!/bin/bash
# Scale/pad a clip to standard 1920x1080 resolution
# Usage: ./scale-clip.sh <input> [output]
# Example: ./scale-clip.sh demo.mp4
# Example: ./scale-clip.sh demo.mp4 demo-scaled.mp4

set -e
source "$(dirname "$0")/common.sh"

INPUT="$1"
OUTPUT="$2"

if [ -z "$INPUT" ]; then
    echo "Usage: $0 <input> [output]"
    echo "Example: $0 demo.mp4"
    exit 1
fi

# Handle relative paths
if [[ "$INPUT" != /* ]]; then
    INPUT="$CLIPS/$INPUT"
fi

# Default output name
if [ -z "$OUTPUT" ]; then
    BASENAME=$(basename "$INPUT" .mp4)
    OUTPUT="$CLIPS/${BASENAME}-scaled.mp4"
else
    if [[ "$OUTPUT" != /* ]]; then
        OUTPUT="$CLIPS/$OUTPUT"
    fi
fi

if [ ! -f "$INPUT" ]; then
    echo "Error: Input not found: $INPUT"
    exit 1
fi

# Get current resolution
RESOLUTION=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$INPUT")
echo "=== Scaling clip ==="
echo "Input: $INPUT"
echo "Current resolution: $RESOLUTION"
echo "Target: 1920x1080"
echo "Output: $OUTPUT"

$VID_SCALE \
    --input "$INPUT" \
    --output "$OUTPUT" \
    --width 1920 \
    --height 1080 \
    --pad

echo "Created: $OUTPUT"
