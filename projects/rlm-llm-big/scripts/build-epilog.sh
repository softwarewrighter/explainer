#!/bin/bash
# Build epilog: reference like/subscribe + 5s music extension
set -e
source "$(dirname "$0")/common.sh"

REF_EPILOG="$REFDIR/epilog/99b-epilog.mp4"
EPILOG_BASE="$CLIPS/99b-epilog.mp4"
EPILOG_EXT="$CLIPS/99c-epilog-ext.mp4"
EXT_DURATION=5

echo "=== Building Epilog ==="
echo "Reference: $REF_EPILOG"
echo "Music: $MUSIC"
echo "Extension: ${EXT_DURATION}s"

if [ ! -f "$REF_EPILOG" ]; then
    echo "Error: Reference epilog not found: $REF_EPILOG"
    exit 1
fi

mkdir -p "$CLIPS"

# Step 1: Copy and normalize reference epilog (24000 Hz mono -> 44100 Hz stereo)
echo "Step 1: Normalizing reference epilog..."
ffmpeg -y -i "$REF_EPILOG" -c:v copy -c:a aac -ar 44100 -ac 2 "$EPILOG_BASE" 2>/dev/null

# Step 2: Extract last frame
echo "Step 2: Extracting last frame..."
LAST_FRAME="/tmp/epilog-last-frame-$$.png"
ffmpeg -y -sseof -0.1 -i "$EPILOG_BASE" -vframes 1 "$LAST_FRAME" 2>/dev/null

# Step 3: Create extension with music (fade out in last 0.5s only)
echo "Step 3: Creating ${EXT_DURATION}s extension..."
$VID_IMAGE \
    --image "$LAST_FRAME" \
    --output "/tmp/epilog-ext-silent-$$.mp4" \
    --duration "$EXT_DURATION"

# Add music with fade out at end only
ffmpeg -y -i "/tmp/epilog-ext-silent-$$.mp4" -i "$MUSIC" \
    -filter_complex "[1:a]volume=0.23,atrim=0:${EXT_DURATION},afade=t=out:st=$(echo "$EXT_DURATION - 0.5" | bc):d=0.5,asetpts=PTS-STARTPTS[a]" \
    -map 0:v -map "[a]" \
    -c:v copy -c:a aac -ar 44100 -ac 2 \
    -shortest "$EPILOG_EXT" 2>/dev/null

rm -f "$LAST_FRAME" "/tmp/epilog-ext-silent-$$.mp4"

# Normalize volumes
"$(dirname "$0")/normalize-volume.sh" "$EPILOG_BASE" -25
"$(dirname "$0")/normalize-volume.sh" "$EPILOG_EXT" -25

echo ""
echo "=== Result ==="
echo "Base: $EPILOG_BASE"
echo "Extension: $EPILOG_EXT"
