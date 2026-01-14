#!/bin/bash
# Build final video: normalize all clips to 44100 Hz stereo, then concatenate
# CRITICAL: All clips must have consistent audio format before concat
set -e
source "$(dirname "$0")/common.sh"

OUTPUT="$WORK/final-rlm-war-and-peace-demo.mp4"
TEMP_DIR="/tmp/rlm-war-and-peace-demo-final-$$"
CONCAT_LIST="$TEMP_DIR/concat-list.txt"

mkdir -p "$TEMP_DIR"

echo "=== Building Final RLM War and Peace Demo Video ==="
echo ""

# Normalize function - ensures 44100 Hz stereo AAC
normalize_clip() {
    local input="$1"
    local output="$2"
    local name=$(basename "$input")

    # Check current format
    local format=$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate,channels -of csv=p=0 "$input" 2>/dev/null)

    if [ "$format" = "44100,2" ]; then
        # Already correct format, just copy
        cp "$input" "$output"
        echo "  $name: already 44100/stereo (copied)"
    else
        # Need to re-encode audio
        ffmpeg -y -i "$input" \
            -c:v copy \
            -c:a aac -ar 44100 -ac 2 -b:a 192k \
            "$output" 2>/dev/null
        echo "  $name: normalized from $format to 44100/stereo"
    fi
}

echo "Step 1: Normalizing all clips to 44100 Hz stereo..."
echo ""

# Define clip order - UPDATE THIS LIST FOR YOUR PROJECT
CLIP_ORDER=(
    "00-title.mp4"
    "02-hook-composited.mp4"
    # Add more clips here as they are created
    "68-cta-composited.mp4"
    "99-epilog-final.mp4"
)

# Normalize each clip
> "$CONCAT_LIST"
for clip in "${CLIP_ORDER[@]}"; do
    INPUT="$CLIPS/$clip"
    OUTPUT_CLIP="$TEMP_DIR/$clip"

    if [ ! -f "$INPUT" ]; then
        echo "  WARNING: Missing $clip - skipping"
        continue
    fi

    normalize_clip "$INPUT" "$OUTPUT_CLIP"
    echo "$OUTPUT_CLIP" >> "$CONCAT_LIST"
done

echo ""
echo "Step 2: Concatenating clips..."
TOTAL=$(wc -l < "$CONCAT_LIST" | tr -d ' ')
echo "  Total clips: $TOTAL"
echo ""

if [ "$TOTAL" -eq 0 ]; then
    echo "ERROR: No clips found to concatenate!"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Use vid-concat with --reencode for safety
$VID_CONCAT \
    --list "$CONCAT_LIST" \
    --output "$OUTPUT" \
    --reencode \
    --print-duration

echo ""
echo "Step 3: Verifying final output..."

# Verify audio format
AUDIO_INFO=$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate,channels -of csv=p=0 "$OUTPUT")
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT")

echo "  Duration: ${DURATION}s ($(echo "scale=0; $DURATION / 60" | bc)m $(echo "scale=0; $DURATION % 60" | bc | cut -d. -f1)s)"
echo "  Audio: $AUDIO_INFO (should be 44100,2)"

# Check audio levels
echo ""
echo "Step 4: Audio level check..."
$VID_VOLUME --input "$OUTPUT" --print-levels

# Cleanup temp files
rm -rf "$TEMP_DIR"

echo ""
echo "=== Final video ready: $OUTPUT ==="
