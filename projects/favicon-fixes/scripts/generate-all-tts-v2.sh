#!/bin/bash
# Generate TTS for all narration clips - V2 version for section-based segmentation
# Only regenerates if script text has changed or audio missing
# Stores .used file alongside .wav to track what text was used

set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

SCRIPTS_DIR="$WORK/scripts"
AUDIO_DIR="$WORK/audio/narration"
SEGMENTS_DIR="$WORK/clips/segments"
HTML_FILE="$SEGMENTS_DIR/index.html"
SEGMENT_MAP="$WORK/segment-map-v2.json"

mkdir -p "$AUDIO_DIR"

echo "=== Smart TTS Generation (V2) ==="
echo "Only regenerating clips with changed text"
echo ""

# Get total clips count
TOTAL_CLIPS=$(jq '[.sections[].clips[]] | length' "$SEGMENT_MAP")
NUM_SECTIONS=$(jq '.sections | length' "$SEGMENT_MAP")

echo "Total sections: $NUM_SECTIONS"
echo "Total clips: $TOTAL_CLIPS"
echo ""

# Function to regenerate HTML with current audio status
update_html() {
    cat > "$HTML_FILE" << 'HTMLHEADER'
<!DOCTYPE html>
<html>
<head>
    <title>Favicon Fixes - V2 TTS Preview</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }
        h1 { color: #4CAF50; }
        h2 { color: #ff9800; margin-top: 30px; border-bottom: 1px solid #444; padding-bottom: 10px; }
        .stats { background: #2d2d2d; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .progress { background: #333; border-radius: 4px; height: 20px; margin: 10px 0; overflow: hidden; }
        .progress-bar { background: #4CAF50; height: 100%; transition: width 0.3s; }
        .clip { display: flex; margin: 10px 0; padding: 10px; background: #2d2d2d; border-radius: 8px; gap: 15px; border-left: 4px solid #444; }
        .clip.describe { border-left-color: #4CAF50; }
        .clip.joke { border-left-color: #ff9800; }
        .clip.summary { border-left-color: #2196F3; }
        .clip.has-audio { opacity: 1; }
        .clip.pending { opacity: 0.6; }
        .clip-id { font-size: 18px; font-weight: bold; color: #4CAF50; min-width: 50px; }
        video { width: 320px; border-radius: 4px; }
        .info { flex-grow: 1; }
        .meta { font-size: 11px; color: #666; margin-bottom: 5px; }
        .role { display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 10px; text-transform: uppercase; margin-left: 10px; }
        .role.describe { background: #4CAF50; color: white; }
        .role.joke { background: #ff9800; color: white; }
        .role.summary { background: #2196F3; color: white; }
        .narration { color: #fff; font-size: 14px; line-height: 1.5; margin: 8px 0; padding: 8px; background: #1a1a1a; border-radius: 4px; }
        audio { width: 100%; height: 28px; margin-top: 8px; }
        .pending-msg { color: #888; font-style: italic; font-size: 12px; margin-top: 8px; }
        .audio-duration { color: #888; font-size: 11px; margin-left: 10px; }
        .keyboard-help { background: #2d2d2d; padding: 8px 15px; border-radius: 8px; margin-bottom: 15px; font-size: 11px; color: #888; }
    </style>
</head>
<body>
    <h1>Favicon Fixes - TTS Generation</h1>
    <div class="keyboard-help">Manually refresh browser (Cmd+R) to see new clips</div>
HTMLHEADER

    local completed=$(ls "$AUDIO_DIR"/clip-*.wav 2>/dev/null | wc -l | tr -d ' ')
    local pct=$((completed * 100 / TOTAL_CLIPS))

    cat >> "$HTML_FILE" << HTMLSTATS
    <div class="stats">
        <strong>TTS Progress:</strong> ${completed} / ${TOTAL_CLIPS} clips
        <div class="progress"><div class="progress-bar" style="width: ${pct}%"></div></div>
        <div style="margin-top: 10px; font-size: 12px; color: #888;">
            <span class="role describe">describe</span> What's happening
            <span class="role joke">joke</span> Commentary
            <span class="role summary">summary</span> Wrap up
        </div>
    </div>
HTMLSTATS

    # Add sections
    for s in $(seq 0 $((NUM_SECTIONS - 1))); do
        local SECTION_ID=$(jq -r ".sections[$s].id" "$SEGMENT_MAP")
        local SECTION_NAME=$(jq -r ".sections[$s].name" "$SEGMENT_MAP")
        local SECTION_START=$(jq -r ".sections[$s].start" "$SEGMENT_MAP")
        local SECTION_END=$(jq -r ".sections[$s].end" "$SEGMENT_MAP")
        local NUM_CLIPS=$(jq ".sections[$s].clips | length" "$SEGMENT_MAP")

        cat >> "$HTML_FILE" << SECTIONHTML
    <h2>Section $SECTION_ID: $SECTION_NAME (${SECTION_START}s-${SECTION_END}s)</h2>
SECTIONHTML

        for c in $(seq 0 $((NUM_CLIPS - 1))); do
            local CLIP_ID=$(jq -r ".sections[$s].clips[$c].clip_id" "$SEGMENT_MAP")
            local START=$(jq -r ".sections[$s].clips[$c].start" "$SEGMENT_MAP")
            local END=$(jq -r ".sections[$s].clips[$c].end" "$SEGMENT_MAP")
            local ROLE=$(jq -r ".sections[$s].clips[$c].role" "$SEGMENT_MAP")
            local NARRATION=$(jq -r ".sections[$s].clips[$c].narration" "$SEGMENT_MAP")
            local DURATION=$((END - START))

            local AUDIO_FILE="$AUDIO_DIR/clip-${CLIP_ID}.wav"
            local HAS_AUDIO="pending"
            local AUDIO_HTML='<div class="pending-msg">Audio pending</div>'

            if [[ -f "$AUDIO_FILE" ]]; then
                HAS_AUDIO="has-audio"
                local AUDIO_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_FILE" 2>/dev/null || echo "0")
                AUDIO_DUR=$(printf "%.1fs" "$AUDIO_DUR")
                AUDIO_HTML="<audio controls preload=\"metadata\"><source src=\"../../audio/narration/clip-${CLIP_ID}.wav\" type=\"audio/wav\"></audio><span class=\"audio-duration\">${AUDIO_DUR}</span>"
            fi

            cat >> "$HTML_FILE" << CLIPHTML
    <div class="clip $ROLE $HAS_AUDIO">
        <div class="clip-id">$CLIP_ID</div>
        <div><video controls preload="metadata"><source src="clip-${CLIP_ID}.mp4" type="video/mp4"></video></div>
        <div class="info">
            <div class="meta">${START}s-${END}s (${DURATION}s) <span class="role $ROLE">$ROLE</span></div>
            <div class="narration">$NARRATION</div>
            $AUDIO_HTML
        </div>
    </div>
CLIPHTML
        done
    done

    echo "</body></html>" >> "$HTML_FILE"
}

# Initial HTML
update_html

GENERATED=0
SKIPPED=0

# Process all clips
for s in $(seq 0 $((NUM_SECTIONS - 1))); do
    NUM_CLIPS=$(jq ".sections[$s].clips | length" "$SEGMENT_MAP")

    for c in $(seq 0 $((NUM_CLIPS - 1))); do
        CLIP_ID=$(jq -r ".sections[$s].clips[$c].clip_id" "$SEGMENT_MAP")

        SCRIPT_FILE="$SCRIPTS_DIR/clip-${CLIP_ID}.txt"
        AUDIO_FILE="$AUDIO_DIR/clip-${CLIP_ID}.wav"
        USED_FILE="$AUDIO_DIR/clip-${CLIP_ID}.used"

        if [[ ! -f "$SCRIPT_FILE" ]]; then
            echo "Clip $CLIP_ID: No script, skipping"
            continue
        fi

        CURRENT_TEXT=$(cat "$SCRIPT_FILE")

        # Check if we need to regenerate
        NEED_REGEN=false
        if [[ ! -f "$AUDIO_FILE" ]]; then
            NEED_REGEN=true
            REASON="no audio"
        elif [[ ! -f "$USED_FILE" ]]; then
            NEED_REGEN=true
            REASON="no .used file"
        else
            USED_TEXT=$(cat "$USED_FILE")
            if [[ "$CURRENT_TEXT" != "$USED_TEXT" ]]; then
                NEED_REGEN=true
                REASON="text changed"
            fi
        fi

        if [[ "$NEED_REGEN" == "true" ]]; then
            echo -n "Clip $CLIP_ID: Generating ($REASON)... "
            $VID_TTS --script "$SCRIPT_FILE" --output "$AUDIO_FILE" --print-duration 2>&1 | grep -E "(duration|Generated)" || true

            # Save what text was used
            cp "$SCRIPT_FILE" "$USED_FILE"

            GENERATED=$((GENERATED + 1))
            update_html
        else
            echo "Clip $CLIP_ID: Up to date, skipping"
            SKIPPED=$((SKIPPED + 1))
        fi
    done
done

# Final HTML update
update_html

echo ""
echo "=== Done ==="
echo "Generated: $GENERATED | Skipped: $SKIPPED"
