#!/bin/bash
# Build a slide clip from SVG + audio
# Usage: ./build-slide.sh <name>
# Example: ./build-slide.sh 03-problem

set -e
source "$(dirname "$0")/common.sh"

NAME="$1"
if [ -z "$NAME" ]; then
    echo "Usage: $0 <name>"
    echo "Example: $0 03-problem"
    exit 1
fi

SVG="$ASSETS/svg/${NAME}.svg"
AUDIO_FILE="$AUDIO/${NAME}.wav"
PNG="$STILLS/${NAME}.png"
OUTPUT="$CLIPS/${NAME}.mp4"

# Check inputs exist
if [ ! -f "$SVG" ]; then
    echo "Error: SVG not found: $SVG"
    exit 1
fi
if [ ! -f "$AUDIO_FILE" ]; then
    echo "Error: Audio not found: $AUDIO_FILE"
    exit 1
fi

# Ensure directories exist
mkdir -p "$STILLS" "$CLIPS"

echo "=== Building slide: $NAME ==="
echo "SVG: $SVG"
echo "Audio: $AUDIO_FILE"

# Convert SVG to PNG
echo "Converting SVG to PNG..."
rsvg-convert -w 1920 -h 1080 "$SVG" -o "$PNG"

# Create video clip
echo "Creating video clip..."
$VID_IMAGE \
    --image "$PNG" \
    --output "$OUTPUT" \
    --audio "$AUDIO_FILE" \
    --effect ken-burns

echo "Created: $OUTPUT"
$VID_VOLUME --input "$OUTPUT" --print-levels
