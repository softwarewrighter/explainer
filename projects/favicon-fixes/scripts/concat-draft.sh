#!/bin/bash
# Concatenate all clips into draft video
# Usage: ./concat-draft.sh

set -e
source "$(dirname "$0")/common.sh"

CONCAT_LIST="$CLIPS/concat-list.txt"
OUTPUT="$WORK/draft-favicon.mp4"

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
# Use vid-volume to show duration (it prints duration in its output)
$VID_VOLUME --input "$OUTPUT" --print-levels
