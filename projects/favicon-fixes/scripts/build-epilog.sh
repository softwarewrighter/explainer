#!/bin/bash
# Build complete epilog: prebuilt narration + 5s music extension
# Usage: ./build-epilog.sh
#
# Structure:
#   - 99b-epilog.mp4: Prebuilt epilog with lip-synced narration (from reference)
#   - 99c-epilog-ext.mp4: 5s extension (last frame + project music)
#   - 99-epilog-final.mp4: Combined output for final concat
#
# Music: Uses MUSIC from common.sh (soaring.mp3 for this project)
#        Different projects use different music - this is the key difference
#
# Based on babyai-hrm pattern: reference epilog + project-specific music extension

set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

# Reference epilog (prebuilt with lip-synced narration)
REF_EPILOG="$REFDIR/epilog/99b-epilog.mp4"

# Output files
EPILOG_BASE="$CLIPS/99b-epilog.mp4"
EPILOG_EXT="$CLIPS/99c-epilog-ext.mp4"
EPILOG_FINAL="$CLIPS/99-epilog-final.mp4"

# Extension settings
EXT_DURATION=5

echo "=== Building Epilog ==="
echo "Reference epilog: $REF_EPILOG"
echo "Music: $MUSIC (soaring.mp3)"
echo "Extension: ${EXT_DURATION}s"
echo ""

# Check inputs
if [ ! -f "$REF_EPILOG" ]; then
    echo "Error: Reference epilog not found: $REF_EPILOG"
    exit 1
fi
if [ ! -f "$MUSIC" ]; then
    echo "Error: Music not found: $MUSIC"
    exit 1
fi

mkdir -p "$CLIPS"

# Step 1: Copy and NORMALIZE reference epilog
# CRITICAL: Reference epilog is 24000 Hz MONO. Must convert to 44100 Hz STEREO
# before concatenation or extension audio will be SILENTLY DROPPED.
echo "Step 1: Copying and normalizing reference epilog..."
ffmpeg -y -i "$REF_EPILOG" -c:v copy -c:a aac -ar 44100 -ac 2 "$EPILOG_BASE" 2>/dev/null
echo "  Converted to 44100 Hz stereo"

# Step 2: Extract last frame from epilog
echo "Step 2: Extracting last frame..."
LAST_FRAME="/tmp/epilog-last-frame-$$.png"
ffmpeg -y -sseof -0.1 -i "$EPILOG_BASE" -vframes 1 "$LAST_FRAME" 2>/dev/null

# Step 3: Create 5s extension with music
echo "Step 3: Creating ${EXT_DURATION}s extension with music..."
# Volume 0.23 brings soaring.mp3 to ~-25 dB (same as title clip)
$VID_IMAGE \
    --image "$LAST_FRAME" \
    --output "/tmp/epilog-ext-silent-$$.mp4" \
    --duration "$EXT_DURATION"

# Add music with same volume as title clip
ffmpeg -y -i "/tmp/epilog-ext-silent-$$.mp4" -i "$MUSIC" \
    -filter_complex "[1:a]volume=0.23,atrim=0:${EXT_DURATION},asetpts=PTS-STARTPTS[a]" \
    -map 0:v -map "[a]" \
    -c:v copy -c:a aac -ar 44100 -ac 2 \
    -shortest "$EPILOG_EXT" 2>/dev/null

# Cleanup temp files
rm -f "$LAST_FRAME" "/tmp/epilog-ext-silent-$$.mp4"

# Step 4: Normalize both clips
echo "Step 4: Normalizing volumes..."
"$SCRIPT_DIR/normalize-volume.sh" "$EPILOG_BASE" -25
"$SCRIPT_DIR/normalize-volume.sh" "$EPILOG_EXT" -25

# Step 5: Concatenate base + extension
echo "Step 5: Concatenating epilog + extension..."
CONCAT_LIST="/tmp/epilog-concat-$$.txt"
echo "file '$EPILOG_BASE'" > "$CONCAT_LIST"
echo "file '$EPILOG_EXT'" >> "$CONCAT_LIST"

ffmpeg -y -f concat -safe 0 -i "$CONCAT_LIST" \
    -c:v libx264 -preset fast -crf 18 \
    -c:a aac -ar 44100 -ac 2 \
    "$EPILOG_FINAL" 2>/dev/null

rm "$CONCAT_LIST"

# Final normalize
"$SCRIPT_DIR/normalize-volume.sh" "$EPILOG_FINAL" -25

# Verify
echo ""
echo "=== Result ==="
echo "Base epilog: $EPILOG_BASE"
echo "Extension: $EPILOG_EXT"
echo "Final: $EPILOG_FINAL"
ffprobe -v error -show_entries format=duration -of csv=p=0 "$EPILOG_FINAL" | xargs printf "Duration: %.2fs\n"
