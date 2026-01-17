#!/bin/bash
# Generate TTS audio from script file
# Usage: ./generate-tts.sh <name> [subdir]
# Examples:
#   ./generate-tts.sh l1-overview           # SVG narration from work/scripts/
#   ./generate-tts.sh 01-problem error-ranking  # VHS narration from work/vhs/error-ranking/scripts/

set -e
source "$(dirname "$0")/common.sh"

NAME="$1"
SUBDIR="$2"

if [ -z "$NAME" ]; then
    echo "Usage: $0 <name> [subdir]"
    echo ""
    echo "Examples:"
    echo "  $0 l1-overview              # SVG narration"
    echo "  $0 01-problem error-ranking # VHS demo narration"
    exit 1
fi

if [ -n "$SUBDIR" ]; then
    # VHS demo narration
    SCRIPT="$VHS/$SUBDIR/scripts/${NAME}.txt"
    OUTPUT="$VHS/$SUBDIR/audio/${NAME}.wav"
    mkdir -p "$VHS/$SUBDIR/audio"
else
    # SVG narration
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
