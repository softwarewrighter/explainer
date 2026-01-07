#!/bin/bash
# Build a composited clip with lip-synced avatar overlay
# Usage: ./build-avatar-clip.sh <name>
# Example: ./build-avatar-clip.sh 29-cta

set -e
source "$(dirname "$0")/common.sh"

NAME="$1"
if [ -z "$NAME" ]; then
    echo "Usage: $0 <name>"
    echo "Example: $0 29-cta"
    exit 1
fi

SVG="$ASSETS/svg/${NAME}.svg"
AUDIO_FILE="$AUDIO/${NAME}.wav"
PNG="$STILLS/${NAME}.png"
BASE_CLIP="$CLIPS/${NAME}.mp4"
STRETCHED="$AVATAR/${NAME}-stretched.mp4"
LIPSYNCED="$AVATAR/${NAME}-lipsynced.mp4"
OUTPUT="$CLIPS/${NAME}-composited.mp4"

# Check inputs exist
if [ ! -f "$SVG" ]; then
    echo "Error: SVG not found: $SVG"
    exit 1
fi
if [ ! -f "$AUDIO_FILE" ]; then
    echo "Error: Audio not found: $AUDIO_FILE"
    exit 1
fi

# Ensure avatar directory exists
mkdir -p "$AVATAR"

# Get audio duration
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")
echo "=== Building avatar clip: $NAME ==="
echo "Audio duration: ${DURATION}s"

# Step 1: Convert SVG to PNG
echo "Step 1: Converting SVG to PNG..."
rsvg-convert -w 1920 -h 1080 "$SVG" -o "$PNG"

# Step 2: Create base video clip
echo "Step 2: Creating base clip..."
$VID_IMAGE \
    --image "$PNG" \
    --output "$BASE_CLIP" \
    --audio "$AUDIO_FILE" \
    --effect ken-burns

# Step 3: Stretch avatar to match duration
echo "Step 3: Stretching avatar..."
$VID_AVATAR \
    --facing center \
    --duration "$DURATION" \
    --reference-dir "$REFDIR" \
    --output "$STRETCHED"

# Step 4: Lip-sync avatar
echo "Step 4: Lip-syncing avatar..."
$VID_LIPSYNC \
    --avatar "$STRETCHED" \
    --audio "$AUDIO_FILE" \
    --output "$LIPSYNCED"

# Step 5: Composite avatar onto base clip
echo "Step 5: Compositing..."
$VID_COMPOSITE \
    --content "$BASE_CLIP" \
    --avatar "$LIPSYNCED" \
    --output "$OUTPUT"

echo "Created: $OUTPUT"
$VID_VOLUME --input "$OUTPUT" --print-levels
