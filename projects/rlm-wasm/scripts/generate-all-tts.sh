#!/bin/bash
# Generate all TTS audio files for the rlm-wasm project

set -e
SCRIPT_DIR="$(dirname "$0")"

echo "=== Generating SVG Narration TTS ==="
"$SCRIPT_DIR/generate-tts.sh" l1-overview
"$SCRIPT_DIR/generate-tts.sh" l2-overview
"$SCRIPT_DIR/generate-tts.sh" limitations
"$SCRIPT_DIR/generate-tts.sh" future

echo ""
echo "=== Generating VHS Demo TTS: error-ranking ==="
"$SCRIPT_DIR/generate-tts.sh" 01-problem error-ranking
"$SCRIPT_DIR/generate-tts.sh" 02-command error-ranking
"$SCRIPT_DIR/generate-tts.sh" 03-results error-ranking
"$SCRIPT_DIR/generate-tts.sh" 04-how error-ranking

echo ""
echo "=== Generating VHS Demo TTS: percentiles ==="
"$SCRIPT_DIR/generate-tts.sh" 01-problem percentiles
"$SCRIPT_DIR/generate-tts.sh" 02-command percentiles
"$SCRIPT_DIR/generate-tts.sh" 03-results percentiles
"$SCRIPT_DIR/generate-tts.sh" 04-how percentiles

echo ""
echo "=== Generating VHS Demo TTS: unique-ips ==="
"$SCRIPT_DIR/generate-tts.sh" 01-problem unique-ips
"$SCRIPT_DIR/generate-tts.sh" 02-command unique-ips
"$SCRIPT_DIR/generate-tts.sh" 03-results unique-ips
"$SCRIPT_DIR/generate-tts.sh" 04-how unique-ips

echo ""
echo "=== All TTS generation complete ==="
