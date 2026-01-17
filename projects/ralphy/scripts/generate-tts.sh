#!/bin/bash
# Generate TTS audio from script file
# Usage: ./generate-tts.sh <name> [subdir]
# Examples:
#   ./generate-tts.sh hook                    # From work/scripts/
#   ./generate-tts.sh 01-prd demo             # From work/vhs/demo/scripts/

set -e
source "$(dirname "$0")/common.sh"

NAME="$1"
SUBDIR="$2"

if [ -z "$NAME" ]; then
    echo "Usage: $0 <name> [subdir]"
    exit 1
fi

if [ -n "$SUBDIR" ]; then
    SCRIPT="$VHS/$SUBDIR/scripts/${NAME}.txt"
    OUTPUT="$VHS/$SUBDIR/audio/${NAME}.wav"
    mkdir -p "$VHS/$SUBDIR/audio"
else
    SCRIPT="$WORK/scripts/${NAME}.txt"
    OUTPUT="$AUDIO/${NAME}.wav"
    mkdir -p "$AUDIO"
fi

if [ ! -f "$SCRIPT" ]; then
    echo "Error: Script not found: $SCRIPT"
    exit 1
fi

echo "=== Generating TTS: $NAME ==="
echo "Script: $SCRIPT"
echo "Content: $(cat "$SCRIPT")"
echo ""

$VID_TTS \
    --script "$SCRIPT" \
    --output "$OUTPUT" \
    --pad-start 0.3 \
    --pad-end 0.3 \
    --print-duration

echo "Created: $OUTPUT"
