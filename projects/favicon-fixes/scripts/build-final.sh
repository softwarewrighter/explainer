#!/bin/bash
# Build final video: prolog + narrated OBS clips + epilog
# CRITICAL: All clips must be 44100 Hz stereo before concat
set -e
source "$(dirname "$0")/common.sh"

NARRATED="$WORK/clips/narrated"
CONCAT_LIST="$WORK/clips/concat-list.txt"
OUTPUT="$WORK/final-favicon-fixes.mp4"
TEMP_DIR="/tmp/final-$$"

mkdir -p "$TEMP_DIR"

echo "=== Building Final Video ==="
echo ""

# Normalize function - ensures 44100 Hz stereo
normalize_clip() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" \
        -c:v copy \
        -c:a aac -ar 44100 -ac 2 -b:a 192k \
        "$output" 2>/dev/null
}

echo "Step 1: Normalizing bookend clips..."

# Normalize prolog clips
normalize_clip "$CLIPS/00-title.mp4" "$TEMP_DIR/00-title.mp4"
echo "  00-title.mp4 normalized"
normalize_clip "$CLIPS/02-hook.mp4" "$TEMP_DIR/02-hook.mp4"
echo "  02-hook.mp4 normalized"

# Normalize epilog clips
normalize_clip "$CLIPS/68-cta.mp4" "$TEMP_DIR/68-cta.mp4"
echo "  68-cta.mp4 normalized"
normalize_clip "$CLIPS/99-epilog-final.mp4" "$TEMP_DIR/99-epilog-final.mp4"
echo "  99-epilog-final.mp4 normalized"

echo ""
echo "Step 2: Creating concat list..."

# Build concat list (vid-concat uses plain paths, one per line)
> "$CONCAT_LIST"

# Prolog
echo "$TEMP_DIR/00-title.mp4" >> "$CONCAT_LIST"
echo "$TEMP_DIR/02-hook.mp4" >> "$CONCAT_LIST"

# OBS clips (narrated)
for i in $(seq 1 229); do
    CLIP_ID=$(printf "%03d" $i)
    CLIP="$NARRATED/clip-${CLIP_ID}.mp4"
    if [ -f "$CLIP" ]; then
        echo "$CLIP" >> "$CONCAT_LIST"
    else
        echo "WARNING: Missing $CLIP"
    fi
done

# Epilog
echo "$TEMP_DIR/68-cta.mp4" >> "$CONCAT_LIST"
echo "$TEMP_DIR/99-epilog-final.mp4" >> "$CONCAT_LIST"

TOTAL=$(wc -l < "$CONCAT_LIST" | tr -d ' ')
echo "  Total clips: $TOTAL"

echo ""
echo "Step 3: Concatenating with ffmpeg demuxer..."

# Create ffmpeg concat demuxer format (file 'path')
DEMUXER_LIST="$WORK/clips/demuxer-list.txt"
> "$DEMUXER_LIST"
while read -r path; do
    echo "file '$path'" >> "$DEMUXER_LIST"
done < "$CONCAT_LIST"

# Use ffmpeg concat demuxer (much lighter than filter for many files)
ffmpeg -y -f concat -safe 0 -i "$DEMUXER_LIST" \
    -c:v libx264 -preset fast -crf 18 \
    -c:a aac -ar 44100 -ac 2 -b:a 192k \
    "$OUTPUT"

echo ""
echo "Step 4: Verifying final output..."

# Verify audio format
AUDIO_INFO=$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate,channels -of csv=p=0 "$OUTPUT")
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT")

echo "  Duration: ${DURATION}s"
echo "  Audio: $AUDIO_INFO (should be 44100,2)"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=== Final video: $OUTPUT ==="
