#!/bin/bash
# Build VHS demo video with narration overlay
# Usage: ./build-vhs-narration.sh <demo-name>
# Example: ./build-vhs-narration.sh error-ranking
#
# This script overlays 4 narration clips on a VHS recording:
#   01-problem.wav - Introduction to the problem (quarter 1)
#   02-command.wav - Explanation of the command (quarter 2)
#   03-results.wav - Description of results (quarter 3)
#   04-how.wav     - How it worked technically (quarter 4)
#
# Each 10s video quarter is slowed to match narration + 0.5s padding.
# Original video audio is muted to avoid interference.
#
# NOTE: This script uses ffmpeg directly because no Rust CLI exists
# for multi-track audio overlay at specific timestamps. The script
# serves as the documented, repeatable process per project guidelines.

set -e
source "$(dirname "$0")/common.sh"

DEMO_NAME="$1"

if [ -z "$DEMO_NAME" ]; then
    echo "Usage: $0 <demo-name>"
    echo "Example: $0 error-ranking"
    echo ""
    echo "Available demos:"
    echo "  error-ranking"
    echo "  percentiles"
    echo "  unique-ips"
    exit 1
fi

# Paths
VIDEO_IN="$VHS/l2-${DEMO_NAME}.mp4"
AUDIO_DIR="$VHS/${DEMO_NAME}/audio"
OUTPUT="$VHS/l2-${DEMO_NAME}-narrated.mp4"
TEMP_DIR="/tmp/vhs-narration-$$"

# Validate inputs
if [ ! -f "$VIDEO_IN" ]; then
    echo "Error: Video not found: $VIDEO_IN"
    exit 1
fi

if [ ! -d "$AUDIO_DIR" ]; then
    echo "Error: Audio directory not found: $AUDIO_DIR"
    exit 1
fi

mkdir -p "$TEMP_DIR"

echo "=== Building VHS Demo with Narration: $DEMO_NAME ==="
echo "  Video: $VIDEO_IN"
echo "  Audio dir: $AUDIO_DIR"
echo ""

# Get video duration and frame rate
VIDEO_DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$VIDEO_IN")
echo "Original video duration: ${VIDEO_DURATION}s"

# Source quarter duration (from original video)
SRC_QUARTER=10
PADDING=0.5

# Get narration durations
AUDIO_1="$AUDIO_DIR/01-problem.wav"
AUDIO_2="$AUDIO_DIR/02-command.wav"
AUDIO_3="$AUDIO_DIR/03-results.wav"
AUDIO_4="$AUDIO_DIR/04-how.wav"

DUR_1=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_1")
DUR_2=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_2")
DUR_3=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_3")
DUR_4=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_4")

# Calculate target durations (narration + padding)
TGT_1=$(echo "$DUR_1 + $PADDING" | bc)
TGT_2=$(echo "$DUR_2 + $PADDING" | bc)
TGT_3=$(echo "$DUR_3 + $PADDING" | bc)
TGT_4=$(echo "$DUR_4 + $PADDING" | bc)

# Calculate slowdown factors (target/source)
SLOW_1=$(echo "scale=6; $TGT_1 / $SRC_QUARTER" | bc)
SLOW_2=$(echo "scale=6; $TGT_2 / $SRC_QUARTER" | bc)
SLOW_3=$(echo "scale=6; $TGT_3 / $SRC_QUARTER" | bc)
SLOW_4=$(echo "scale=6; $TGT_4 / $SRC_QUARTER" | bc)

echo ""
echo "Quarter timing (each 10s source → narration + ${PADDING}s):"
echo "  Q1: ${DUR_1}s narration → ${TGT_1}s video (${SLOW_1}x slowdown)"
echo "  Q2: ${DUR_2}s narration → ${TGT_2}s video (${SLOW_2}x slowdown)"
echo "  Q3: ${DUR_3}s narration → ${TGT_3}s video (${SLOW_3}x slowdown)"
echo "  Q4: ${DUR_4}s narration → ${TGT_4}s video (${SLOW_4}x slowdown)"

TOTAL_DURATION=$(echo "$TGT_1 + $TGT_2 + $TGT_3 + $TGT_4" | bc)
echo ""
echo "Total output duration: ${TOTAL_DURATION}s"
echo ""

# Step 1: Extract, slow, and add narration to each quarter
echo "Step 1: Building each quarter with its narration..."

for i in 1 2 3 4; do
    eval slow=\$SLOW_$i
    eval tgt=\$TGT_$i
    eval audio=\$AUDIO_$i
    start=$(echo "($i - 1) * $SRC_QUARTER" | bc)

    echo "  Quarter $i: ${start}s-$((start + SRC_QUARTER))s → ${tgt}s (with narration)"

    # Extract and slow video quarter, add its single narration
    ffmpeg -y -ss $start -t $SRC_QUARTER -i "$VIDEO_IN" \
        -i "$audio" \
        -filter_complex "
            [0:v]setpts=${slow}*PTS[v];
            [1:a]adelay=0.25s:all=1[a]
        " \
        -map "[v]" \
        -map "[a]" \
        -c:v libx264 -preset fast -crf 18 \
        -c:a aac -ar 44100 -ac 2 -b:a 192k \
        -t "$tgt" \
        "$TEMP_DIR/q${i}.mp4" 2>/dev/null
done

# Step 2: Concatenate quarters with their narrations
echo ""
echo "Step 2: Concatenating quarters..."

cat > "$TEMP_DIR/concat.txt" << EOF
file 'q1.mp4'
file 'q2.mp4'
file 'q3.mp4'
file 'q4.mp4'
EOF

ffmpeg -y -f concat -safe 0 -i "$TEMP_DIR/concat.txt" \
    -c:v copy \
    -c:a copy \
    "$OUTPUT" 2>/dev/null

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=== Created: $OUTPUT ==="

# Verify output
OUT_DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT")
echo "Output duration: ${OUT_DURATION}s (expected: ~${TOTAL_DURATION}s)"

# Print audio levels
echo ""
echo "Audio levels:"
$VID_VOLUME --input "$OUTPUT" --print-levels
