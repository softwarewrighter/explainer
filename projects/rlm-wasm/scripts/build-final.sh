#!/bin/bash
# Build final video: normalize all clips to 44100 Hz stereo, then concatenate
# CRITICAL: All clips must have consistent audio format before concat
set -e
source "$(dirname "$0")/common.sh"

OUTPUT="$WORK/final-rlm-wasm.mp4"
PREVIEW="$WORK/clips/preview.mp4"
TEMP_DIR="/tmp/rlm-wasm-final-$$"
CONCAT_LIST="$TEMP_DIR/concat-list.txt"

mkdir -p "$TEMP_DIR"

echo "=== Building Final RLM WASM Video ==="
echo ""

# Normalize function - ensures 44100 Hz stereo AAC and 1920x1080 resolution
normalize_clip() {
    local input="$1"
    local output="$2"
    local name=$(basename "$input")

    # Check current format
    local audio_format=$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate,channels -of csv=p=0 "$input" 2>/dev/null)
    local video_res=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$input" 2>/dev/null)

    local needs_audio=false
    local needs_video=false

    if [ "$audio_format" != "44100,2" ]; then
        needs_audio=true
    fi

    if [ "$video_res" != "1920,1080" ]; then
        needs_video=true
    fi

    if [ "$needs_audio" = false ] && [ "$needs_video" = false ]; then
        # Already correct format, just copy
        cp "$input" "$output"
        echo "  $name: already 1920x1080 44100/stereo (copied)"
    elif [ "$needs_video" = true ]; then
        # Need to scale video and possibly fix audio
        ffmpeg -y -i "$input" \
            -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
            -c:v libx264 -preset fast -crf 18 \
            -c:a aac -ar 44100 -ac 2 -b:a 192k \
            "$output" 2>/dev/null
        echo "  $name: scaled from $video_res to 1920x1080, audio to 44100/stereo"
    else
        # Only need to fix audio
        ffmpeg -y -i "$input" \
            -c:v copy \
            -c:a aac -ar 44100 -ac 2 -b:a 192k \
            "$output" 2>/dev/null
        echo "  $name: normalized audio from $audio_format to 44100/stereo"
    fi
}

echo "Step 1: Normalizing all clips to 44100 Hz stereo..."
echo ""

# Define clip order - matches video structure:
# 1. Title with music intro
# 2. Hook with avatar
# 3. L1 DSL overview (SVG with narration)
# 4. L1 Visualization demo (web UI with narration)
# 5. L2 WASM overview (SVG with narration)
# 6-8. VHS CLI demos (error-ranking, percentiles, unique-ips)
# 9-11. L2 WASM web UI demos (unique IPs, error ranking, status codes)
# 12. WASM Limitations (SVG with narration)
# 13. More to Come (SVG with narration)
# 14. CTA with avatar
# 15. Epilog (like/subscribe)
# 16. Epilog extension with music fade-out
CLIP_ORDER=(
    "$CLIPS/00-title.mp4"
    "$CLIPS/01-hook-composited.mp4"
    "$CLIPS/03-l1-dsl.mp4"
    "$VHS/l2-visualization-narrated.mp4"
    "$CLIPS/04-l2-wasm.mp4"
    "$VHS/l2-error-ranking-narrated.mp4"
    "$VHS/l2-percentiles-narrated.mp4"
    "$VHS/l2-unique-ips-narrated.mp4"
    "$VHS/wasm-demo/l2-wasm-demo-narrated.mp4"
    "$VHS/wasm-demo2/l2-error-ranking-webui-narrated.mp4"
    "$VHS/wasm-demo3/l2-status-codes-webui-narrated.mp4"
    "$VHS/wasm-demo4/l2-percentiles-webui-narrated.mp4"
    "$CLIPS/08-limitations.mp4"
    "$CLIPS/09-future.mp4"
    "$CLIPS/14-cta-composited.mp4"
    "$CLIPS/99b-epilog.mp4"
    "$CLIPS/99c-epilog-ext.mp4"
)

# Normalize each clip
> "$CONCAT_LIST"
for clip in "${CLIP_ORDER[@]}"; do
    INPUT="$clip"
    BASENAME=$(basename "$clip")
    OUTPUT_CLIP="$TEMP_DIR/$BASENAME"

    if [ ! -f "$INPUT" ]; then
        echo "  WARNING: Missing $BASENAME - skipping"
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

# Copy to preview location
cp "$OUTPUT" "$PREVIEW"
echo ""
echo "Preview copied to: $PREVIEW"

# Cleanup temp files
rm -rf "$TEMP_DIR"

echo ""
echo "=== Final video ready: $OUTPUT ==="
