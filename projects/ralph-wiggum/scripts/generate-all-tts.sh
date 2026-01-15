#!/bin/bash
# Generate all TTS narration files

set -e
SCRIPT_DIR="$(dirname "$0")"

for script in "$SCRIPT_DIR/../work/scripts/"*.txt; do
    name=$(basename "$script" .txt)
    echo "=== Processing: $name ==="
    "$SCRIPT_DIR/generate-tts.sh" "$name"
    echo ""
done

echo "=== All TTS generated ==="
ls -la "$SCRIPT_DIR/../work/audio/"
