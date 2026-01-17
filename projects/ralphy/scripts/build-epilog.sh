#!/bin/bash
# Build epilog extension: still from epilog + music fade out
set -e
source "$(dirname "$0")/common.sh"

EPILOG_STILL="$WORK/stills/epilog-still.jpg"
OUTPUT="$CLIPS/99c-epilog-ext.mp4"
DURATION=5

echo "=== Building Epilog Extension ==="
echo "Still: $EPILOG_STILL"
echo "Music: $MUSIC"
echo "Duration: ${DURATION}s"

if [ ! -f "$EPILOG_STILL" ]; then
    echo "Error: Still not found: $EPILOG_STILL"
    exit 1
fi
if [ ! -f "$MUSIC" ]; then
    echo "Error: Music not found: $MUSIC"
    exit 1
fi

mkdir -p "$CLIPS"

# Create video with ken-burns
$VID_IMAGE \
    --image "$EPILOG_STILL" \
    --output "/tmp/epilog-silent-$$.mp4" \
    --duration "$DURATION" \
    --effect ken-burns

# Add music with fade out (volume 0.23, fade out last 3s)
ffmpeg -y -i "/tmp/epilog-silent-$$.mp4" -i "$MUSIC" \
    -filter_complex "[1:a]volume=0.23,atrim=0:${DURATION},afade=t=out:st=2:d=3,asetpts=PTS-STARTPTS[a]" \
    -map 0:v -map "[a]" \
    -c:v copy -c:a aac -ar 44100 -ac 2 \
    -shortest "$OUTPUT" 2>/dev/null

rm -f "/tmp/epilog-silent-$$.mp4"

echo "Created: $OUTPUT"
ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT" | xargs printf "Duration: %.2fs\n"
