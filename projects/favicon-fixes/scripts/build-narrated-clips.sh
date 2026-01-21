#!/bin/bash
# Build narrated clips: speed up video to audio+1s, add audio, normalize
set -e
source "$(dirname "$0")/common.sh"

SEGMENTS="$WORK/clips/segments"
NARRATION="$WORK/audio/narration"
OUTPUT_DIR="$WORK/clips/narrated"
TEMP_DIR="/tmp/narrated-$$"

mkdir -p "$OUTPUT_DIR" "$TEMP_DIR"

echo "=== Building Narrated Clips ==="
echo "Input segments: $SEGMENTS"
echo "Input narration: $NARRATION"
echo "Output: $OUTPUT_DIR"
echo ""

PROCESSED=0
SKIPPED=0

for i in $(seq 1 229); do
    CLIP_ID=$(printf "%03d" $i)
    VID="$SEGMENTS/clip-${CLIP_ID}.mp4"
    AUD="$NARRATION/clip-${CLIP_ID}.wav"
    OUT="$OUTPUT_DIR/clip-${CLIP_ID}.mp4"

    if [ ! -f "$VID" ]; then
        echo "SKIP $CLIP_ID: no video"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    if [ ! -f "$AUD" ]; then
        echo "SKIP $CLIP_ID: no audio"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    # Get durations
    VID_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$VID")
    AUD_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUD")

    # Target: video should be audio + 1 second
    TARGET_DUR=$(echo "$AUD_DUR + 1" | bc)

    # Calculate speedup factor
    SPEEDUP=$(echo "scale=4; $VID_DUR / $TARGET_DUR" | bc)

    # Don't slow down videos (speedup < 1)
    if (( $(echo "$SPEEDUP < 1" | bc -l) )); then
        SPEEDUP=1
        TARGET_DUR=$VID_DUR
    fi

    printf "clip-%s: vid=%.1fs aud=%.1fs -> %.1fs (%.2fx) " "$CLIP_ID" "$VID_DUR" "$AUD_DUR" "$TARGET_DUR" "$SPEEDUP"

    # Speed up video and scale to 1920x1080 (drop audio)
    SPED_UP="$TEMP_DIR/sped-${CLIP_ID}.mp4"
    ffmpeg -y -i "$VID" \
        -filter:v "setpts=PTS/$SPEEDUP,scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
        -an \
        -c:v libx264 -preset fast -crf 18 \
        "$SPED_UP" 2>/dev/null

    # Add audio, normalize to 44100 Hz stereo
    ffmpeg -y -i "$SPED_UP" -i "$AUD" \
        -c:v copy \
        -c:a aac -ar 44100 -ac 2 -b:a 128k \
        -map 0:v -map 1:a \
        -shortest \
        "$OUT" 2>/dev/null

    # Verify output duration
    OUT_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT")
    printf "out=%.1fs\n" "$OUT_DUR"

    PROCESSED=$((PROCESSED + 1))

    # Clean temp file
    rm -f "$SPED_UP"
done

rm -rf "$TEMP_DIR"

echo ""
echo "=== Done ==="
echo "Processed: $PROCESSED"
echo "Skipped: $SKIPPED"
echo "Output: $OUTPUT_DIR"
