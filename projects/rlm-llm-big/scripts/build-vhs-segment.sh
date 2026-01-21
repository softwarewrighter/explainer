#!/bin/bash
# Build a narrated VHS segment: extract, speed adjust, add audio
# Usage: ./build-vhs-segment.sh <segment-name> <start-time> <end-time>
# Example: ./build-vhs-segment.sh 03a-setup 0 12
set -e

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

NAME="$1"
START="$2"
END="$3"

if [ -z "$NAME" ] || [ -z "$START" ] || [ -z "$END" ]; then
    echo "Usage: $0 <segment-name> <start-time> <end-time>"
    echo "Example: $0 03a-setup 0 12"
    exit 1
fi

AUDIO_FILE="$AUDIO/${NAME}.wav"
OUTPUT="$CLIPS/${NAME}.mp4"
TEMP_DIR="/tmp/vhs-segment-$$"

mkdir -p "$TEMP_DIR"

if [ ! -f "$VHS_SOURCE" ]; then
    echo "ERROR: VHS source not found: $VHS_SOURCE"
    exit 1
fi

if [ ! -f "$AUDIO_FILE" ]; then
    echo "ERROR: Audio not found: $AUDIO_FILE"
    exit 1
fi

# Calculate video segment duration
VID_DUR=$(echo "$END - $START" | bc)
echo "=== Building VHS Segment: $NAME ==="
echo "VHS source: $VHS_SOURCE"
echo "Segment: ${START}s to ${END}s (${VID_DUR}s)"

# Get audio duration
AUD_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")
echo "Audio duration: ${AUD_DUR}s"

# Target: video should match audio duration (with small padding)
TARGET_DUR=$(echo "$AUD_DUR + 0.5" | bc)

# Calculate speedup factor (video_dur / target_dur)
SPEEDUP=$(echo "scale=4; $VID_DUR / $TARGET_DUR" | bc)

# Don't slow down videos (speedup < 1)
if (( $(echo "$SPEEDUP < 1" | bc -l) )); then
    echo "Video shorter than audio, using 1x speed"
    SPEEDUP=1
fi

printf "Speed adjustment: %.2fx\n" "$SPEEDUP"

# Step 1: Extract and speed up video using vid-speedup
SPED_UP="$TEMP_DIR/sped.mp4"
echo "Extracting and speeding up video..."
"$VID_SPEEDUP" \
    --input "$VHS_SOURCE" \
    --output "$SPED_UP" \
    --start "$START" \
    --duration "$VID_DUR" \
    --speed "$SPEEDUP" \
    --verbose

# Step 2: Add audio track
echo "Adding audio..."
ffmpeg -y -i "$SPED_UP" -i "$AUDIO_FILE" \
    -c:v copy \
    -c:a aac -ar 44100 -ac 2 -b:a 192k \
    -map 0:v -map 1:a \
    -shortest \
    "$OUTPUT" 2>/dev/null

# Step 3: Normalize volume
echo "Normalizing..."
"$SCRIPT_DIR/normalize-volume.sh" "$OUTPUT"

# Verify output
OUT_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT")
echo ""
echo "=== Complete ==="
echo "Output: $OUTPUT"
printf "Duration: %.1fs\n" "$OUT_DUR"

# Cleanup
rm -rf "$TEMP_DIR"
