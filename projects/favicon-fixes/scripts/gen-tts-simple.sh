#!/bin/bash
set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

SCRIPTS_DIR="$WORK/scripts"
AUDIO_DIR="$WORK/audio/narration"
SEGMENT_MAP="$WORK/segment-map-v2.json"

echo "Current progress: $(ls "$AUDIO_DIR"/clip-*.wav 2>/dev/null | wc -l | tr -d ' ') clips"
echo ""

# Process each clip ID
jq -r '[.sections[].clips[].clip_id] | .[]' "$SEGMENT_MAP" | while IFS= read -r CLIP_ID; do
    SCRIPT_FILE="$SCRIPTS_DIR/clip-${CLIP_ID}.txt"
    AUDIO_FILE="$AUDIO_DIR/clip-${CLIP_ID}.wav"
    USED_FILE="$AUDIO_DIR/clip-${CLIP_ID}.used"

    if [[ ! -f "$SCRIPT_FILE" ]]; then
        echo "Clip $CLIP_ID: no script"
        continue
    fi

    # Skip if audio exists and text unchanged
    if [[ -f "$AUDIO_FILE" ]] && [[ -f "$USED_FILE" ]]; then
        if diff -q "$SCRIPT_FILE" "$USED_FILE" > /dev/null 2>&1; then
            echo "Clip $CLIP_ID: skip"
            continue
        fi
    fi

    echo -n "Clip $CLIP_ID: "
    $VID_TTS --script "$SCRIPT_FILE" --output "$AUDIO_FILE" --print-duration 2>&1 | grep -oE "Raw TTS duration: [0-9.]+s" || echo "done"
    cp "$SCRIPT_FILE" "$USED_FILE"
done

echo ""
echo "=== Complete ==="
echo "$(ls "$AUDIO_DIR"/clip-*.wav 2>/dev/null | wc -l | tr -d ' ') clips generated"
