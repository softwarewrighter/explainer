#!/bin/bash
# Generate TTS audio from script file
# Usage: ./generate-tts.sh <name>
# Example: ./generate-tts.sh 03-problem

set -e
source "$(dirname "$0")/common.sh"

NAME="$1"
if [ -z "$NAME" ]; then
    echo "Usage: $0 <name>"
    echo "Example: $0 03-problem"
    exit 1
fi

SCRIPT="$WORK/scripts/${NAME}.txt"
OUTPUT="$AUDIO/${NAME}.wav"

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
