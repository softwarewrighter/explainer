#!/bin/bash
# Build a video clip from SVG with narration audio
# Usage: ./build-svg-clip.sh <svg-name> <audio-name> <output-name>
# Example: ./build-svg-clip.sh rlm-l1-dsl l1-overview 03-l1-dsl
#
# The clip duration = audio duration + 0.5 seconds
# SVG is converted to PNG at 1920x1080, then vid-image creates the video

set -e
source "$(dirname "$0")/common.sh"

SVG_NAME="$1"
AUDIO_NAME="$2"
OUTPUT_NAME="$3"

if [ -z "$SVG_NAME" ] || [ -z "$AUDIO_NAME" ] || [ -z "$OUTPUT_NAME" ]; then
    echo "Usage: $0 <svg-name> <audio-name> <output-name>"
    echo "Example: $0 rlm-l1-dsl l1-overview 03-l1-dsl"
    exit 1
fi

SVG_FILE="$ASSETS/svg/${SVG_NAME}.svg"
AUDIO_FILE="$AUDIO/${AUDIO_NAME}.wav"
PNG_FILE="$WORK/png/${SVG_NAME}.png"
OUTPUT_FILE="$CLIPS/${OUTPUT_NAME}.mp4"

# Validate inputs
if [ ! -f "$SVG_FILE" ]; then
    echo "Error: SVG not found: $SVG_FILE"
    exit 1
fi

if [ ! -f "$AUDIO_FILE" ]; then
    echo "Error: Audio not found: $AUDIO_FILE"
    exit 1
fi

mkdir -p "$WORK/png"
mkdir -p "$CLIPS"

echo "=== Building SVG Clip: $OUTPUT_NAME ==="
echo "  SVG: $SVG_FILE"
echo "  Audio: $AUDIO_FILE"

# Step 1: Convert SVG to PNG at 1920x1080
echo ""
echo "Step 1: Converting SVG to PNG..."
# Use rsvg-convert if available, otherwise use Inkscape
if command -v rsvg-convert &> /dev/null; then
    rsvg-convert -w 1920 -h 1080 "$SVG_FILE" -o "$PNG_FILE"
elif command -v inkscape &> /dev/null; then
    inkscape "$SVG_FILE" --export-type=png --export-filename="$PNG_FILE" -w 1920 -h 1080
else
    echo "Error: Neither rsvg-convert nor inkscape found. Install librsvg or inkscape."
    exit 1
fi
echo "  Created: $PNG_FILE"

# Step 2: Get audio duration and add 0.5 seconds
echo ""
echo "Step 2: Calculating duration..."
AUDIO_DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")
# Add 0.5 seconds using bc for floating point math
CLIP_DURATION=$(echo "$AUDIO_DURATION + 0.5" | bc)
echo "  Audio duration: ${AUDIO_DURATION}s"
echo "  Clip duration: ${CLIP_DURATION}s (audio + 0.5s)"

# Step 3: Create video with vid-image
echo ""
echo "Step 3: Creating video clip..."
$VID_IMAGE \
    --image "$PNG_FILE" \
    --audio "$AUDIO_FILE" \
    --duration "$CLIP_DURATION" \
    --output "$OUTPUT_FILE" \
    --print-duration

echo ""
echo "=== Created: $OUTPUT_FILE ==="
