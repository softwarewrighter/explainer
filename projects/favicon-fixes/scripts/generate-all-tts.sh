#!/bin/bash
# Generate TTS for all narration clips - SMART version
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
SEGMENT_MAP="$WORK/segment-map.json"

mkdir -p "$AUDIO_DIR"

echo "=== Smart TTS Generation ==="
echo "Only regenerating clips with changed text"
echo ""

# Function to regenerate HTML with current audio status
update_html() {
    cat > "$HTML_FILE" << 'HTMLHEADER'
<!DOCTYPE html>
<html>
<head>
    <title>Favicon Fixes - Narration Review</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }
        h1 { color: #4CAF50; }
        .stats { background: #2d2d2d; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .progress { background: #333; border-radius: 4px; height: 20px; margin: 10px 0; overflow: hidden; }
        .progress-bar { background: #4CAF50; height: 100%; transition: width 0.3s; }
        .segment { display: flex; margin: 15px 0; padding: 15px; background: #2d2d2d; border-radius: 8px; gap: 15px; border-left: 4px solid #444; }
        .segment:hover { background: #3d3d3d; }
        .segment.has-audio { border-left-color: #4CAF50; }
        .segment.pending { border-left-color: #666; opacity: 0.7; }
        .segment-num { font-size: 24px; font-weight: bold; color: #4CAF50; min-width: 40px; text-align: center; }
        .video-container { flex-shrink: 0; }
        video { width: 400px; border-radius: 4px; }
        .info { flex-grow: 1; display: flex; flex-direction: column; gap: 8px; }
        .path { font-family: monospace; font-size: 11px; color: #666; }
        .time { color: #ffeb3b; font-size: 13px; }
        .summary-text { color: #888; font-size: 12px; }
        .narration-text { color: #fff; font-size: 14px; line-height: 1.5; padding: 10px; background: #1a1a1a; border-radius: 4px; }
        .audio-section { margin-top: 8px; padding: 10px; background: #1a1a1a; border-radius: 4px; }
        .audio-section.has-audio { border: 1px solid #4CAF50; }
        .audio-section.pending { border: 1px solid #444; }
        .audio-label { font-size: 11px; color: #4CAF50; text-transform: uppercase; margin-bottom: 5px; }
        .audio-path { font-family: monospace; font-size: 10px; color: #666; margin-top: 5px; }
        audio { width: 100%; height: 32px; }
        .pending-msg { color: #888; font-style: italic; font-size: 12px; }
        .duration { color: #888; font-size: 11px; margin-left: 10px; }
        .keyboard-help { background: #2d2d2d; padding: 8px 15px; border-radius: 8px; margin-bottom: 15px; font-size: 11px; color: #888; }
    </style>
    <!-- Auto-refresh disabled - manually refresh to see new clips -->
</head>
<body>
    <h1>Favicon Fixes - TTS Generation</h1>
    <div class="keyboard-help">Manually refresh browser (Cmd+R) to see new clips</div>
HTMLHEADER

    local completed=$(ls "$AUDIO_DIR"/clip-*.wav 2>/dev/null | wc -l | tr -d ' ')
    local total=58
    local pct=$((completed * 100 / total))

    cat >> "$HTML_FILE" << HTMLSTATS
    <div class="stats">
        <strong>TTS Progress:</strong> ${completed} / ${total} clips
        <div class="progress"><div class="progress-bar" style="width: ${pct}%"></div></div>
    </div>
HTMLSTATS

    for i in $(seq 1 58); do
        local PADDED=$(printf "%02d" $i)
        local START=$(jq -r ".segments[$((i-1))].start" "$SEGMENT_MAP")
        local END=$(jq -r ".segments[$((i-1))].end" "$SEGMENT_MAP")
        local SUMMARY=$(jq -r ".segments[$((i-1))].summary" "$SEGMENT_MAP")
        local DURATION=$((END - START))

        local SCRIPT_FILE="$SCRIPTS_DIR/clip-${PADDED}.txt"
        local AUDIO_FILE="$AUDIO_DIR/clip-${PADDED}.wav"
        local NARRATION=""
        [[ -f "$SCRIPT_FILE" ]] && NARRATION=$(cat "$SCRIPT_FILE")

        local HAS_AUDIO="pending"
        local AUDIO_HTML='<div class="pending-msg">Generating...</div>'
        local AUDIO_DUR=""

        if [[ -f "$AUDIO_FILE" ]]; then
            HAS_AUDIO="has-audio"
            AUDIO_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$AUDIO_FILE" 2>/dev/null || echo "0")
            AUDIO_DUR=$(printf "%.1fs" "$AUDIO_DUR")
            AUDIO_HTML="<audio controls preload=\"metadata\"><source src=\"../../audio/narration/clip-${PADDED}.wav\" type=\"audio/wav\"></audio><div class=\"audio-path\">clip-${PADDED}.wav <span class=\"duration\">${AUDIO_DUR}</span></div>"
        fi

        cat >> "$HTML_FILE" << HTMLSEG
    <div class="segment ${HAS_AUDIO}" id="clip-${PADDED}">
        <div class="segment-num">${i}</div>
        <div class="video-container">
            <video controls preload="metadata">
                <source src="clip-${PADDED}.mp4" type="video/mp4">
            </video>
        </div>
        <div class="info">
            <div class="path">clip-${PADDED}.mp4 | ${START}s-${END}s (${DURATION}s)</div>
            <div class="summary-text">${SUMMARY}</div>
            <div class="narration-text">${NARRATION}</div>
            <div class="audio-section ${HAS_AUDIO}">
                <div class="audio-label">TTS Audio</div>
                ${AUDIO_HTML}
            </div>
        </div>
    </div>
HTMLSEG
    done

    echo "</body></html>" >> "$HTML_FILE"
}

# Initial HTML
update_html

GENERATED=0
SKIPPED=0

for i in $(seq 1 58); do
    PADDED=$(printf "%02d" $i)
    SCRIPT_FILE="$SCRIPTS_DIR/clip-${PADDED}.txt"
    AUDIO_FILE="$AUDIO_DIR/clip-${PADDED}.wav"
    USED_FILE="$AUDIO_DIR/clip-${PADDED}.used"

    if [[ ! -f "$SCRIPT_FILE" ]]; then
        echo "Clip $PADDED: No script, skipping"
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
        echo -n "Clip $PADDED: Generating ($REASON)... "
        $VID_TTS --script "$SCRIPT_FILE" --output "$AUDIO_FILE" --print-duration 2>&1 | grep -E "(duration|Generated)" || true

        # Save what text was used
        cp "$SCRIPT_FILE" "$USED_FILE"

        GENERATED=$((GENERATED + 1))

        # Only update HTML every 10 clips to avoid interrupting playback
        if (( GENERATED % 10 == 0 )); then
            update_html
        fi
    else
        echo "Clip $PADDED: Up to date, skipping"
        SKIPPED=$((SKIPPED + 1))
    fi
done

# Final HTML update
update_html

echo ""
echo "=== Done ==="
echo "Generated: $GENERATED | Skipped: $SKIPPED"
