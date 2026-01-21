#!/bin/bash
# Build title clip: 2s heart image + 5s title slide + 7s music
# Usage: ./build-title.sh
#
# Structure:
#   - 2 seconds: heart-favicon2.jpg (with ken-burns effect)
#   - 5 seconds: 00-title.svg rendered to PNG
#   - Music: soaring.mp3 (same as epilog) for full 7 seconds
#
# Output: 00-title-final.mp4 (1920x1080, 44100Hz stereo)

set -e
source "$(dirname "$0")/common.sh"

# Inputs
HEART_IMAGE="$ASSETS/images/heart-favicon2.jpg"
TITLE_SVG="$ASSETS/svg/00-title.svg"
# MUSIC is defined in common.sh as soaring.mp3

# Intermediate files
TITLE_PNG="$STILLS/00-title.png"
HEART_CLIP="$CLIPS/00-title-heart.mp4"
SLIDE_CLIP="$CLIPS/00-title-slide.mp4"
VIDEO_ONLY="$CLIPS/00-title-video.mp4"

# Final output
OUTPUT="$CLIPS/00-title-final.mp4"

# Durations
HEART_DUR=2
SLIDE_DUR=5
TOTAL_DUR=7

echo "=== Building Title Clip ==="
echo "Heart image: $HEART_IMAGE (${HEART_DUR}s)"
echo "Title SVG: $TITLE_SVG (${SLIDE_DUR}s)"
echo "Music: $MUSIC (${TOTAL_DUR}s) - soaring.mp3"
echo "Output: $OUTPUT"
echo ""

# Check inputs
for f in "$HEART_IMAGE" "$TITLE_SVG" "$MUSIC"; do
    if [ ! -f "$f" ]; then
        echo "Error: File not found: $f"
        exit 1
    fi
done

mkdir -p "$CLIPS" "$STILLS"

# Step 1: Render SVG to PNG
echo "Step 1: Rendering SVG to PNG..."
rsvg-convert -w 1920 -h 1080 "$TITLE_SVG" -o "$TITLE_PNG"

# Step 2: Create 2s heart clip (no audio)
echo "Step 2: Creating ${HEART_DUR}s heart clip..."
$VID_IMAGE \
    --image "$HEART_IMAGE" \
    --output "$HEART_CLIP" \
    --duration "$HEART_DUR" \
    --effect ken-burns

# Step 3: Create 5s slide clip (no audio)
echo "Step 3: Creating ${SLIDE_DUR}s slide clip..."
$VID_IMAGE \
    --image "$TITLE_PNG" \
    --output "$SLIDE_CLIP" \
    --duration "$SLIDE_DUR"

# Step 4: Concatenate heart + slide (video only)
echo "Step 4: Concatenating heart + slide..."
CONCAT_LIST="/tmp/title-concat-$$.txt"
echo "file '$HEART_CLIP'" > "$CONCAT_LIST"
echo "file '$SLIDE_CLIP'" >> "$CONCAT_LIST"

ffmpeg -y -f concat -safe 0 -i "$CONCAT_LIST" \
    -c:v libx264 -preset fast -crf 18 \
    -an "$VIDEO_ONLY" 2>/dev/null

rm "$CONCAT_LIST"

# Step 5: Add music (soaring.mp3) with proper volume
echo "Step 5: Adding music (soaring.mp3)..."
# Volume 0.23 brings soaring.mp3 to ~-25 dB to match reference epilog
# Reference epilog (99b-epilog.mp4) is at -25.4 dB
# Calculation: -16.7dB at 0.6 -> need -8.3dB more -> 0.6 * 10^(-8.3/20) ≈ 0.23
ffmpeg -y -i "$VIDEO_ONLY" -i "$MUSIC" \
    -filter_complex "[1:a]volume=0.23,atrim=0:${TOTAL_DUR},asetpts=PTS-STARTPTS[a]" \
    -map 0:v -map "[a]" \
    -c:v copy -c:a aac -ar 44100 -ac 2 \
    -shortest "$OUTPUT" 2>/dev/null

# Cleanup intermediate files
rm -f "$HEART_CLIP" "$SLIDE_CLIP" "$VIDEO_ONLY"

# Step 6: Normalize volume to target level (-25 dB)
echo "Step 6: Normalizing volume..."
"$(dirname "$0")/normalize-volume.sh" "$OUTPUT" -25

# Verify output
echo ""
echo "=== Result ==="
echo "Output: $OUTPUT"
ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT" | xargs printf "Duration: %.2fs\n"
ffprobe -v error -show_entries stream=width,height,sample_rate -of csv=p=0 "$OUTPUT" | head -2
