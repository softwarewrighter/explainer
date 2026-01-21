#!/bin/bash
# Apply narration corrections: update segment-map, generate TTS, calculate speeds
set -e
source "$(dirname "$0")/common.sh"

CORRECTIONS="/tmp/corrections-list.txt"
SEGMENT_MAP="$WORK/segment-map-v2.json"
NARRATION_DIR="$WORK/audio/narration"
SEGMENTS_DIR="$WORK/clips/segments"

echo "=== Applying Narration Corrections ==="
echo ""

# Create backup
cp "$SEGMENT_MAP" "$SEGMENT_MAP.bak"
echo "Backed up segment map"

# Process each correction
UPDATED=0
GENERATED=0

while IFS='|' read -r clip_id new_text; do
    # Remove quotes from new_text
    new_text=$(echo "$new_text" | sed 's/^"//;s/"$//')

    # Pad clip_id to 3 digits
    padded_id=$(printf "%03d" "$clip_id")

    # Update segment-map-v2.json
    # Use jq to update the narration for this clip
    jq --arg cid "$clip_id" --arg txt "$new_text" '
        .sections[].clips |= map(
            if .clip_id == $cid then .narration = $txt else . end
        )
    ' "$SEGMENT_MAP" > "$SEGMENT_MAP.tmp" && mv "$SEGMENT_MAP.tmp" "$SEGMENT_MAP"

    # Write new script file
    SCRIPT_FILE="$NARRATION_DIR/clip-${padded_id}.txt"
    echo "$new_text" > "$SCRIPT_FILE"

    UPDATED=$((UPDATED + 1))

    # Progress every 20
    if [ $((UPDATED % 20)) -eq 0 ]; then
        echo "Updated $UPDATED clips..."
    fi

done < "$CORRECTIONS"

echo ""
echo "Updated $UPDATED narrations in segment map"
echo ""
echo "=== Generating TTS for updated clips ==="
echo ""

# Now generate TTS for each updated clip
while IFS='|' read -r clip_id new_text; do
    padded_id=$(printf "%03d" "$clip_id")
    SCRIPT_FILE="$NARRATION_DIR/clip-${padded_id}.txt"
    AUDIO_FILE="$NARRATION_DIR/clip-${padded_id}.wav"
    USED_FILE="$NARRATION_DIR/clip-${padded_id}.txt.used"

    # Check if we need to regenerate (script changed)
    if [ -f "$USED_FILE" ] && diff -q "$SCRIPT_FILE" "$USED_FILE" > /dev/null 2>&1; then
        continue  # Skip, already generated
    fi

    # Generate TTS
    DURATION=$($VID_TTS --script "$SCRIPT_FILE" --output "$AUDIO_FILE" --print-duration 2>&1 | grep -E "^[0-9]" | head -1)

    # Copy script to .used
    cp "$SCRIPT_FILE" "$USED_FILE"

    GENERATED=$((GENERATED + 1))
    printf "clip-%s: %ss\n" "$padded_id" "$DURATION"

done < "$CORRECTIONS"

echo ""
echo "Generated TTS for $GENERATED clips"
echo ""
echo "=== Done ==="
