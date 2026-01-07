#!/bin/bash
# Concatenate all clips into draft video
# Usage: ./concat-draft.sh

set -e
source "$(dirname "$0")/common.sh"

CONCAT_LIST="$CLIPS/concat-list.txt"
OUTPUT="$WORK/draft-babyai-hrm.mp4"

if [ ! -f "$CONCAT_LIST" ]; then
    echo "Error: Concat list not found: $CONCAT_LIST"
    echo "Create it with clip filenames, one per line"
    exit 1
fi

echo "=== Concatenating draft ==="
echo "List: $CONCAT_LIST"
echo "Output: $OUTPUT"
echo ""

# Show what will be concatenated
echo "Clips to concatenate:"
cat "$CONCAT_LIST" | head -20
TOTAL=$(wc -l < "$CONCAT_LIST" | tr -d ' ')
echo "... ($TOTAL clips total)"
echo ""

$VID_CONCAT \
    --list "$CONCAT_LIST" \
    --output "$OUTPUT" \
    --reencode

echo ""
echo "=== Final draft ==="
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT")
MINUTES=$(echo "$DURATION / 60" | bc)
SECONDS=$(echo "$DURATION % 60" | bc)
printf "Duration: %.0f:%05.2f\n" "$MINUTES" "$SECONDS"

$VID_VOLUME --input "$OUTPUT" --print-levels
