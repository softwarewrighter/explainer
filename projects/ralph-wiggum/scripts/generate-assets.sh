#!/bin/bash
# Generate video assets from script.json
# Usage: ./generate-assets.sh script.json [--segment <id>]

set -e
source "$(dirname "$0")/common.sh"

SCRIPT_FILE="${1:-script.json}"
SINGLE_SEGMENT=""

shift || true
while [[ $# -gt 0 ]]; do
    case $1 in
        --segment) SINGLE_SEGMENT="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if [[ ! -f "$SCRIPT_FILE" ]]; then
    echo "Script file not found: $SCRIPT_FILE"
    exit 1
fi

mkdir -p "$CLIPS" "$AUDIO" "$WORK/vhs" "$WORK/svg"

echo "=== Asset Generator ==="
echo "Script: $SCRIPT_FILE"
echo ""

# Get segment count
SEGMENT_COUNT=$(jq '.segments | length' "$SCRIPT_FILE")
echo "Total segments: $SEGMENT_COUNT"
echo ""

# Process each segment
for ((i=0; i<SEGMENT_COUNT; i++)); do
    SEGMENT=$(jq ".segments[$i]" "$SCRIPT_FILE")
    ID=$(echo "$SEGMENT" | jq -r '.id')
    TYPE=$(echo "$SEGMENT" | jq -r '.type')
    DURATION=$(echo "$SEGMENT" | jq -r '.duration // 10')
    NARRATION=$(echo "$SEGMENT" | jq -r '.narration // ""')

    # Skip if filtering by segment
    if [[ -n "$SINGLE_SEGMENT" && "$ID" != "$SINGLE_SEGMENT" ]]; then
        continue
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Segment: $ID ($TYPE, ${DURATION}s)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    case "$TYPE" in
        cli)
            # Generate VHS tape and record
            CLI=$(echo "$SEGMENT" | jq -r '.cli // "claude"')
            VHS_TAPE=$(echo "$SEGMENT" | jq -r '.vhs_tape // ""')

            if [[ -n "$VHS_TAPE" ]]; then
                echo "  Recording CLI demo with VHS..."
                TAPE_FILE="$WORK/vhs/${ID}.tape"
                echo "$VHS_TAPE" > "$TAPE_FILE"

                cd "$WORK/vhs"
                vhs "$TAPE_FILE" 2>&1 | tail -3
                mv "${ID}.mp4" "$CLIPS/" 2>/dev/null || true
                cd - > /dev/null
                echo "  ✓ CLI recording: $CLIPS/${ID}.mp4"
            else
                echo "  ⚠ No VHS tape defined, skipping"
            fi
            ;;

        diagram|svg)
            # Generate SVG diagram
            SVG_DESC=$(echo "$SEGMENT" | jq -r '.svg_description // ""')

            if [[ -n "$SVG_DESC" ]]; then
                echo "  Generating SVG diagram..."
                SVG_FILE="$WORK/svg/${ID}.svg"

                # Use Claude to generate SVG
                SVG_PROMPT="Generate an SVG diagram (1920x1080, dark background #0a0512, gold accents #d4af37, green #00ff88) for: $SVG_DESC. Output ONLY the SVG code, no explanation."
                claude --print --dangerously-skip-permissions "$SVG_PROMPT" > "$SVG_FILE" 2>/dev/null

                # Convert to video
                if [[ -f "$SVG_FILE" ]]; then
                    $VID_IMAGE --input "$SVG_FILE" --duration "$DURATION" --output "$CLIPS/${ID}.mp4"
                    echo "  ✓ Diagram: $CLIPS/${ID}.mp4"
                fi
            fi
            ;;

        avatar)
            # Generate avatar with SVG background
            SVG_DESC=$(echo "$SEGMENT" | jq -r '.svg_description // ""')

            echo "  Generating avatar segment..."

            # Generate background SVG
            if [[ -n "$SVG_DESC" ]]; then
                SVG_FILE="$WORK/svg/${ID}-bg.svg"
                SVG_PROMPT="Generate an SVG background (1920x1080, dark gradient #0a0512 to #120818, with: $SVG_DESC). Output ONLY the SVG code."
                claude --print --dangerously-skip-permissions "$SVG_PROMPT" > "$SVG_FILE" 2>/dev/null
            fi

            # Generate TTS first to get duration
            if [[ -n "$NARRATION" ]]; then
                echo "  Generating TTS..."
                $VID_TTS --text "$NARRATION" --output "$AUDIO/${ID}.wav"
                ACTUAL_DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO/${ID}.wav" | cut -d. -f1)
                ACTUAL_DURATION=$((ACTUAL_DURATION + 2))  # Add padding
            fi

            # Create background video
            if [[ -f "$SVG_FILE" ]]; then
                $VID_IMAGE --input "$SVG_FILE" --duration "$ACTUAL_DURATION" --output "$WORK/${ID}-bg.mp4"
            fi

            # Note: Lipsync requires running on hive server
            echo "  ⚠ Avatar lipsync requires manual step:"
            echo "    vid-lipsync --avatar curmudgeon.mp4 --audio $AUDIO/${ID}.wav --server hive:3015"
            echo "  ✓ Background: $WORK/${ID}-bg.mp4"
            echo "  ✓ Audio: $AUDIO/${ID}.wav"
            ;;

        image)
            # Static image with Ken Burns
            IMAGE_PATH=$(echo "$SEGMENT" | jq -r '.image_path // ""')

            if [[ -n "$IMAGE_PATH" && -f "$IMAGE_PATH" ]]; then
                echo "  Creating image segment..."
                $VID_IMAGE --input "$IMAGE_PATH" --duration "$DURATION" --ken-burns --output "$CLIPS/${ID}.mp4"
                echo "  ✓ Image: $CLIPS/${ID}.mp4"
            fi
            ;;

        *)
            echo "  ⚠ Unknown segment type: $TYPE"
            ;;
    esac

    # Generate narration audio for non-avatar segments
    if [[ "$TYPE" != "avatar" && -n "$NARRATION" ]]; then
        echo "  Generating narration TTS..."
        $VID_TTS --text "$NARRATION" --output "$AUDIO/${ID}.wav" 2>/dev/null || echo "  ⚠ TTS failed"
    fi

    echo ""
done

echo "=== Asset Generation Complete ==="
echo ""
echo "Generated clips:"
ls -la "$CLIPS"/*.mp4 2>/dev/null || echo "  (none)"
echo ""
echo "Generated audio:"
ls -la "$AUDIO"/*.wav 2>/dev/null || echo "  (none)"
