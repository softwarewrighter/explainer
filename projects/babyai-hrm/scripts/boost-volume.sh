#!/bin/bash
# Boost audio volume of a clip
# Usage: ./boost-volume.sh <input> <db> [output]
# Example: ./boost-volume.sh 24b-demo.mp4 3
# Example: ./boost-volume.sh 24b-demo.mp4 10 24b-demo-boosted.mp4

set -e
source "$(dirname "$0")/common.sh"

INPUT="$1"
DB="$2"
OUTPUT="$3"

if [ -z "$INPUT" ] || [ -z "$DB" ]; then
    echo "Usage: $0 <input> <db> [output]"
    echo "Example: $0 24b-demo.mp4 3"
    echo "Example: $0 24b-demo.mp4 10 24b-demo-boosted.mp4"
    exit 1
fi

# Handle relative paths
if [[ "$INPUT" != /* ]]; then
    INPUT="$CLIPS/$INPUT"
fi

# Default output name
if [ -z "$OUTPUT" ]; then
    BASENAME=$(basename "$INPUT" .mp4)
    OUTPUT="$CLIPS/${BASENAME}-boosted.mp4"
else
    if [[ "$OUTPUT" != /* ]]; then
        OUTPUT="$CLIPS/$OUTPUT"
    fi
fi

if [ ! -f "$INPUT" ]; then
    echo "Error: Input not found: $INPUT"
    exit 1
fi

echo "=== Boosting volume ==="
echo "Input: $INPUT"
echo "Boost: +${DB}dB"
echo "Output: $OUTPUT"

# Show before
echo "Before:"
$VID_VOLUME --input "$INPUT" --print-levels

# Boost
$VID_VOLUME --input "$INPUT" --output "$OUTPUT" --db "$DB"

# Show after
echo "After:"
$VID_VOLUME --input "$OUTPUT" --print-levels
