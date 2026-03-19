#!/bin/bash
# VoxCPM TTS client using curl (replaces Python gradio_client)
# Usage: ./curl-client.sh --server URL --reference REF.wav --prompt-text "..." --text "..." --output out.wav [--steps 15]
set -e

SERVER=""
REFERENCE=""
PROMPT_TEXT=""
TEXT=""
OUTPUT=""
STEPS=15
CFG=2.0

while [[ $# -gt 0 ]]; do
    case $1 in
        --server|-s) SERVER="$2"; shift 2 ;;
        --reference|-r) REFERENCE="$2"; shift 2 ;;
        --prompt-text|-p) PROMPT_TEXT="$2"; shift 2 ;;
        --text|-t) TEXT="$2"; shift 2 ;;
        --output|-o) OUTPUT="$2"; shift 2 ;;
        --steps) STEPS="$2"; shift 2 ;;
        --cfg) CFG="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ -z "$SERVER" || -z "$REFERENCE" || -z "$PROMPT_TEXT" || -z "$TEXT" || -z "$OUTPUT" ]]; then
    echo "Error: --server, --reference, --prompt-text, --text, and --output are required"
    exit 1
fi

API_PREFIX="$SERVER/gradio_api"

# Step 1: Upload reference audio
UPLOAD_RESULT=$(curl -s -X POST "$API_PREFIX/upload" \
    -F "files=@$REFERENCE")
REF_PATH=$(echo "$UPLOAD_RESULT" | jq -r '.[0]')

if [[ -z "$REF_PATH" || "$REF_PATH" == "null" ]]; then
    echo "Error: Failed to upload reference audio"
    echo "  Response: $UPLOAD_RESULT"
    exit 1
fi

# Step 2: Call generate endpoint
EVENT_RESULT=$(curl -s -X POST "$API_PREFIX/call/generate" \
    -H "Content-Type: application/json" \
    -d "$(jq -n \
        --arg text "$TEXT" \
        --arg ref_path "$REF_PATH" \
        --arg prompt "$PROMPT_TEXT" \
        --argjson cfg "$CFG" \
        --argjson steps "$STEPS" \
        '{data: [$text, {path: $ref_path, meta: {_type: "gradio.FileData"}}, $prompt, $cfg, $steps, false, false]}')")

EVENT_ID=$(echo "$EVENT_RESULT" | jq -r '.event_id')

if [[ -z "$EVENT_ID" || "$EVENT_ID" == "null" ]]; then
    echo "Error: Failed to start generation"
    echo "  Response: $EVENT_RESULT"
    exit 1
fi

# Step 3: Stream SSE and wait for complete event
SSE_OUTPUT=$(curl -s -N "$API_PREFIX/call/generate/$EVENT_ID" 2>&1)

# Parse the complete event data to get the audio URL
AUDIO_URL=$(echo "$SSE_OUTPUT" | grep '^data: \[' | head -1 | sed 's/^data: //' | jq -r '.[0].url')

if [[ -z "$AUDIO_URL" || "$AUDIO_URL" == "null" ]]; then
    # Check for error
    ERROR_MSG=$(echo "$SSE_OUTPUT" | grep '^data:' | tail -1)
    echo "Error: Generation failed"
    echo "  SSE output: $ERROR_MSG"
    exit 1
fi

# Step 4: Download output audio
mkdir -p "$(dirname "$OUTPUT")"
curl -s -o "$OUTPUT" "$AUDIO_URL"

if [[ -f "$OUTPUT" ]]; then
    DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT" 2>/dev/null)
    echo "Success! Audio saved to: $OUTPUT (${DURATION}s)"
else
    echo "Error: Failed to download audio"
    exit 1
fi
