#!/bin/bash
# Build OBS clip with narration synced per-segment
# Each video segment is extended (frame freeze) to match its narration duration
#
# This ensures narration stays aligned with the video content it describes.

set -e
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

# Configuration
TRIM_START=40  # Seconds to trim from start of original OBS
GAP_DURATION=0.2  # Gap between narrations in seconds
OBS_ORIGINAL="/Users/mike/Movies/2026-01-07 22-22-53.mp4"
OUTPUT="$CLIPS/03-67-obs-synced.mp4"
TEMP_DIR="/tmp/obs-synced-$$"

mkdir -p "$TEMP_DIR"

echo "=== Building Synced OBS Clip ==="
echo "Trim: ${TRIM_START}s from start"
echo "Gap between narrations: ${GAP_DURATION}s"

# Get original video duration and calculate trimmed duration
ORIGINAL_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OBS_ORIGINAL")
VIDEO_DUR=$(echo "$ORIGINAL_DUR - $TRIM_START" | bc)
echo "Original OBS: ${ORIGINAL_DUR}s"
echo "After trim: ${VIDEO_DUR}s"

# Count narrations and calculate segment duration
NUM_SEGMENTS=65
SEGMENT_DUR=$(echo "scale=4; $VIDEO_DUR / $NUM_SEGMENTS" | bc)
echo "Segments: $NUM_SEGMENTS"
echo "Video per segment: ${SEGMENT_DUR}s"

# Build segment list
echo ""
echo "Processing segments..."

CONCAT_LIST="$TEMP_DIR/concat.txt"
> "$CONCAT_LIST"

for i in $(seq 0 64); do
    SEG_NUM=$((i + 3))  # Audio files start at 03
    if (( SEG_NUM < 10 )); then
        PREFIX="0$SEG_NUM"
    else
        PREFIX="$SEG_NUM"
    fi

    # Find audio file
    AUDIO_FILE=$(ls "$AUDIO"/${PREFIX}-*.wav 2>/dev/null | head -1)
    if [[ ! -f "$AUDIO_FILE" ]]; then
        echo "  WARNING: No audio for segment $SEG_NUM"
        continue
    fi

    # Get audio duration
    AUDIO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")

    # Calculate video segment times (in original video, after trim offset)
    SEG_START=$(echo "scale=4; $TRIM_START + ($i * $SEGMENT_DUR)" | bc)
    SEG_END=$(echo "scale=4; $SEG_START + $SEGMENT_DUR" | bc)

    # Calculate freeze duration needed (if audio is longer than video segment)
    FREEZE_DUR=$(echo "scale=4; $AUDIO_DUR + $GAP_DURATION - $SEGMENT_DUR" | bc)
    if (( $(echo "$FREEZE_DUR < 0" | bc -l) )); then
        FREEZE_DUR=0
    fi

    # Total segment duration (video + freeze)
    TOTAL_DUR=$(echo "scale=4; $SEGMENT_DUR + $FREEZE_DUR" | bc)

    SEG_FILE="$TEMP_DIR/seg_$(printf '%02d' $i).mp4"

    printf "  Seg %02d: video=%.2fs + freeze=%.2fs = %.2fs (audio=%.2fs)\n" \
        "$SEG_NUM" "$SEGMENT_DUR" "$FREEZE_DUR" "$TOTAL_DUR" "$AUDIO_DUR"

    if (( $(echo "$FREEZE_DUR > 0" | bc -l) )); then
        # Need to extract segment and add frozen frame
        # Extract video segment
        ffmpeg -y -ss "$SEG_START" -i "$OBS_ORIGINAL" -t "$SEGMENT_DUR" \
            -c:v libx264 -preset fast -crf 18 -an \
            "$TEMP_DIR/vid_${i}.mp4" 2>/dev/null

        # Extract last frame
        ffmpeg -y -sseof -0.1 -i "$TEMP_DIR/vid_${i}.mp4" -vframes 1 \
            "$TEMP_DIR/frame_${i}.png" 2>/dev/null

        # Create frozen frame video
        ffmpeg -y -loop 1 -i "$TEMP_DIR/frame_${i}.png" -t "$FREEZE_DUR" \
            -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p -r 60 \
            "$TEMP_DIR/freeze_${i}.mp4" 2>/dev/null

        # Concatenate video + freeze, then add audio
        echo "file '$TEMP_DIR/vid_${i}.mp4'" > "$TEMP_DIR/seg_concat_${i}.txt"
        echo "file '$TEMP_DIR/freeze_${i}.mp4'" >> "$TEMP_DIR/seg_concat_${i}.txt"

        ffmpeg -y -f concat -safe 0 -i "$TEMP_DIR/seg_concat_${i}.txt" \
            -i "$AUDIO_FILE" \
            -c:v copy -c:a aac -b:a 128k -shortest \
            "$SEG_FILE" 2>/dev/null
    else
        # Just extract segment and add audio
        ffmpeg -y -ss "$SEG_START" -i "$OBS_ORIGINAL" -t "$TOTAL_DUR" \
            -i "$AUDIO_FILE" \
            -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 128k -map 0:v -map 1:a \
            "$SEG_FILE" 2>/dev/null
    fi

    echo "file '$SEG_FILE'" >> "$CONCAT_LIST"
done

echo ""
echo "Concatenating all segments..."

# Concatenate all segments
ffmpeg -y -f concat -safe 0 -i "$CONCAT_LIST" \
    -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 192k \
    "$OUTPUT" 2>/dev/null

# Cleanup
rm -rf "$TEMP_DIR"

# Report results
if [[ -f "$OUTPUT" ]]; then
    FINAL_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT")
    echo ""
    echo "=== Success ==="
    echo "Output: $OUTPUT"
    echo "Duration: ${FINAL_DUR}s"
    $VID_VOLUME --input "$OUTPUT" --print-levels 2>&1 | grep -E "(Mean|Max)" || true
else
    echo "ERROR: Output not created"
    exit 1
fi
