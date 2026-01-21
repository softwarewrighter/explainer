#!/bin/bash
# Build OBS clip with video segments aligned to narration content
#
# Each video segment starts when the described content appears in video.
# If audio is longer than video segment, freeze the last frame.
# This ensures narration matches what's shown on screen.

set -e
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

# Configuration
OBS_ORIGINAL="/Users/mike/Movies/2026-01-07 22-22-53.mp4"
TIMELINE="$WORK/scripts/video-timeline-v2.txt"
OUTPUT="$CLIPS/03-67-obs-aligned-v2.mp4"
TEMP_DIR="/tmp/obs-aligned-$$"
GAP=0.15  # Small gap between segments

mkdir -p "$TEMP_DIR"

echo "=== Building Aligned OBS Clip ==="
echo "Timeline: $TIMELINE"
echo "Gap between segments: ${GAP}s"

# Get video duration
VIDEO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OBS_ORIGINAL")
echo "OBS video duration: ${VIDEO_DUR}s"

# Parse timeline into arrays
declare -a NARR_NUMS
declare -a VIDEO_STARTS

while IFS= read -r line; do
    # Skip comments and empty lines
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse: NARR_NUM VIDEO_START
    read -r num start <<< "$line"
    NARR_NUMS+=("$num")
    VIDEO_STARTS+=("$start")
done < "$TIMELINE"

NUM_SEGMENTS=${#NARR_NUMS[@]}
echo "Found $NUM_SEGMENTS segments in timeline"

# Build each segment
CONCAT_LIST="$TEMP_DIR/concat.txt"
> "$CONCAT_LIST"

for i in "${!NARR_NUMS[@]}"; do
    NARR_NUM="${NARR_NUMS[$i]}"
    VIDEO_START="${VIDEO_STARTS[$i]}"

    # Format narration number with leading zero (use 10# to force decimal)
    NARR_NUM_DEC=$((10#$NARR_NUM))
    if (( NARR_NUM_DEC < 10 )); then
        PREFIX="0$NARR_NUM_DEC"
    else
        PREFIX="$NARR_NUM_DEC"
    fi

    # Find audio file
    AUDIO_FILE=$(ls "$AUDIO"/${PREFIX}-*.wav 2>/dev/null | head -1)
    if [[ ! -f "$AUDIO_FILE" ]]; then
        echo "  WARNING: No audio for narration $NARR_NUM, skipping"
        continue
    fi

    # Get audio duration
    AUDIO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")

    # Calculate video segment end (start of next segment, or end of video)
    if (( i + 1 < NUM_SEGMENTS )); then
        VIDEO_END="${VIDEO_STARTS[$((i + 1))]}"
    else
        VIDEO_END="$VIDEO_DUR"
    fi

    # Calculate video segment duration (use printf to ensure proper decimal format)
    VID_SEG_DUR_RAW=$(echo "$VIDEO_END - $VIDEO_START" | bc)
    VID_SEG_DUR=$(printf "%.4f" "$VID_SEG_DUR_RAW")

    # Total duration needed = audio + gap
    TOTAL_NEEDED_RAW=$(echo "$AUDIO_DUR + $GAP" | bc)
    TOTAL_NEEDED=$(printf "%.4f" "$TOTAL_NEEDED_RAW")

    # Calculate freeze duration if needed (use printf to ensure leading zero)
    FREEZE_DUR_RAW=$(echo "$TOTAL_NEEDED - $VID_SEG_DUR" | bc)
    FREEZE_DUR=$(printf "%.4f" "$FREEZE_DUR_RAW")
    if (( $(echo "$FREEZE_DUR < 0" | bc -l) )); then
        FREEZE_DUR="0"
        # Use only as much video as needed
        VID_SEG_DUR="$TOTAL_NEEDED"
    fi

    SEG_FILE="$TEMP_DIR/seg_${PREFIX}.mp4"

    printf "  %s: video=%.1fs @ %ss, audio=%.1fs" \
        "$PREFIX" "$VID_SEG_DUR" "$VIDEO_START" "$AUDIO_DUR"

    if (( $(echo "$FREEZE_DUR > 0.1" | bc -l) )); then
        printf ", freeze=%.1fs" "$FREEZE_DUR"

        # Extract video segment
        if ! ffmpeg -y -ss "$VIDEO_START" -i "$OBS_ORIGINAL" -t "$VID_SEG_DUR" \
            -c:v libx264 -preset fast -crf 18 -an \
            "$TEMP_DIR/vid_${PREFIX}.mp4" 2>/dev/null; then
            echo " [ERROR: extract video]"
            continue
        fi

        # Extract last frame
        if ! ffmpeg -y -sseof -0.1 -i "$TEMP_DIR/vid_${PREFIX}.mp4" -vframes 1 \
            "$TEMP_DIR/frame_${PREFIX}.png" 2>/dev/null; then
            echo " [ERROR: extract frame]"
            continue
        fi

        # Create frozen frame video
        if ! ffmpeg -y -loop 1 -i "$TEMP_DIR/frame_${PREFIX}.png" -t "$FREEZE_DUR" \
            -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p -r 60 \
            "$TEMP_DIR/freeze_${PREFIX}.mp4" 2>/dev/null; then
            echo " [ERROR: create freeze]"
            continue
        fi

        # Concatenate video + freeze
        echo "file '$TEMP_DIR/vid_${PREFIX}.mp4'" > "$TEMP_DIR/concat_${PREFIX}.txt"
        echo "file '$TEMP_DIR/freeze_${PREFIX}.mp4'" >> "$TEMP_DIR/concat_${PREFIX}.txt"

        if ! ffmpeg -y -f concat -safe 0 -i "$TEMP_DIR/concat_${PREFIX}.txt" \
            -i "$AUDIO_FILE" \
            -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 128k -shortest \
            "$SEG_FILE" 2>/dev/null; then
            echo " [ERROR: concat+audio]"
            continue
        fi
    else
        # Just extract video segment and add audio
        if ! ffmpeg -y -ss "$VIDEO_START" -i "$OBS_ORIGINAL" -t "$TOTAL_NEEDED" \
            -i "$AUDIO_FILE" \
            -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 128k \
            -map 0:v -map 1:a -shortest \
            "$SEG_FILE" 2>/dev/null; then
            echo " [ERROR: extract+audio]"
            continue
        fi
    fi

    printf "\n"
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
    echo "=== Normalizing Volume ==="
    "$SCRIPT_DIR/normalize-volume.sh" "$OUTPUT" -25
    echo ""
    echo "=== Success ==="
    echo "Output: $OUTPUT"
    echo "Duration: ${FINAL_DUR}s"
else
    echo "ERROR: Output not created"
    exit 1
fi
