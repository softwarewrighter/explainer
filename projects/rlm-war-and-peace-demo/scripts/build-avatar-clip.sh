#!/bin/bash
# Build a composited clip with lip-synced avatar overlay
# Usage: ./build-avatar-clip.sh <name> [server]
# Example: ./build-avatar-clip.sh 02-hook hive:3015
# Example: ./build-avatar-clip.sh 68-cta hive:3016
#
# IMPORTANT: For parallel builds, use DIFFERENT hive servers to avoid GPU OOM:
#   Terminal 1: ./build-avatar-clip.sh 02-hook hive:3015
#   Terminal 2: ./build-avatar-clip.sh 68-cta hive:3016

set -e
source "$(dirname "$0")/common.sh"

NAME="$1"
LIPSYNC_SERVER="${2:-hive:3015}"  # Default to hive:3015 if not specified

if [ -z "$NAME" ]; then
    echo "Usage: $0 <name> [server]"
    echo "Example: $0 02-hook hive:3015"
    echo "Example: $0 68-cta hive:3016"
    echo ""
    echo "IMPORTANT: Use different hive servers for parallel builds!"
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
if [ ! -f "$AVATAR_SOURCE" ]; then
    echo "Error: Avatar source not found: $AVATAR_SOURCE"
    exit 1
fi

# Ensure directories exist
mkdir -p "$AVATAR" "$STILLS" "$CLIPS"

# Get audio duration
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")
echo "=== Building avatar clip: $NAME ==="
echo "Audio duration: ${DURATION}s"
echo "Avatar source: $AVATAR_SOURCE"
echo "Lipsync server: $LIPSYNC_SERVER"

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
# Use --avatar to specify custom avatar source (instead of --facing + --reference-dir)
echo "Step 3: Stretching avatar to ${DURATION}s..."
$VID_AVATAR \
    --avatar "$AVATAR_SOURCE" \
    --duration "$DURATION" \
    --output "$STRETCHED"

# Step 4: Lip-sync avatar
echo "Step 4: Lip-syncing avatar on $LIPSYNC_SERVER..."
$VID_LIPSYNC \
    --avatar "$STRETCHED" \
    --audio "$AUDIO_FILE" \
    --server "$LIPSYNC_SERVER" \
    --output "$LIPSYNCED"

# Step 5: Composite avatar onto base clip
echo "Step 5: Compositing..."
$VID_COMPOSITE \
    --content "$BASE_CLIP" \
    --avatar "$LIPSYNCED" \
    --output "$OUTPUT"

# Step 6: Normalize volume to target level (-25 dB)
echo "Step 6: Normalizing volume..."
"$(dirname "$0")/normalize-volume.sh" "$OUTPUT" -25

echo ""
echo "=== Result ==="
echo "Created: $OUTPUT"
