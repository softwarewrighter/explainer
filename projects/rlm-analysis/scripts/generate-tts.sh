#!/bin/bash
# Generate TTS audio from script text files
# Usage: ./generate-tts.sh <name>
# Example: ./generate-tts.sh 02-hook

set -e
source "$(dirname "$0")/common.sh"

NAME="$1"
if [ -z "$NAME" ]; then
    echo "Usage: $0 <name>"
    echo "Example: $0 02-hook"
    exit 1
fi

SCRIPT="$SCRIPTS/${NAME}.txt"
OUTPUT="$AUDIO/${NAME}.wav"

if [ ! -f "$SCRIPT" ]; then
    echo "Error: Script not found: $SCRIPT"
    exit 1
fi

# Ensure audio directory exists
mkdir -p "$AUDIO"

echo "=== Generating TTS: $NAME ==="
echo "Script: $SCRIPT"
echo "Output: $OUTPUT"

$VID_TTS \
    --script "$SCRIPT" \
    --output "$OUTPUT" \
    --print-duration

echo "Created: $OUTPUT"
