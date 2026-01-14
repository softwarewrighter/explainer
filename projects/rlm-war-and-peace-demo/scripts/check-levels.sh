#!/bin/bash
# Check audio levels of all clips
# Usage: ./check-levels.sh

set -e
source "$(dirname "$0")/common.sh"

echo "=== Audio Levels Check ==="
echo ""

for clip in "$CLIPS"/*.mp4; do
    if [ -f "$clip" ]; then
        NAME=$(basename "$clip")
        LEVELS=$($VID_VOLUME --input "$clip" --print-levels 2>&1 | grep -E "Mean|Max" | tr '\n' ' ')
        printf "%-35s %s\n" "$NAME" "$LEVELS"
    fi
done

echo ""
echo "Target: Mean -24 to -28 dB for speech, Max < 0 dB"
echo "If mean is below -35 dB, clip is too quiet"
