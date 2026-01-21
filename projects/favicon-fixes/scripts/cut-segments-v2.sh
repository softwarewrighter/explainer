#!/bin/bash
# Cut video into clips based on segment-map-v2.json
# Creates ~229 clips at 7-12 second intervals with narration scripts

set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

SEGMENT_MAP="$WORK/segment-map-v2.json"
SEGMENTS_DIR="$WORK/clips/segments"
SCRIPTS_DIR="$WORK/scripts"
AUDIO_DIR="$WORK/audio/narration"
SOURCE=$(jq -r '.source' "$SEGMENT_MAP")

mkdir -p "$SEGMENTS_DIR" "$SCRIPTS_DIR" "$AUDIO_DIR"

echo "=== Cutting Video (V2 - Logical Sections) ==="
echo "Source: $SOURCE"
echo ""

# Count total clips
TOTAL_CLIPS=$(jq '[.sections[].clips[]] | length' "$SEGMENT_MAP")
NUM_SECTIONS=$(jq '.sections | length' "$SEGMENT_MAP")
echo "Total sections: $NUM_SECTIONS"
echo "Total clips: $TOTAL_CLIPS"
echo ""

# Process using indices instead of piping JSON
for s in $(seq 0 $((NUM_SECTIONS - 1))); do
    SECTION_ID=$(jq -r ".sections[$s].id" "$SEGMENT_MAP")
    SECTION_NAME=$(jq -r ".sections[$s].name" "$SEGMENT_MAP")
    NUM_CLIPS=$(jq ".sections[$s].clips | length" "$SEGMENT_MAP")

    echo "Section $SECTION_ID: $SECTION_NAME ($NUM_CLIPS clips)"

    for c in $(seq 0 $((NUM_CLIPS - 1))); do
        CLIP_ID=$(jq -r ".sections[$s].clips[$c].clip_id" "$SEGMENT_MAP")
        START=$(jq -r ".sections[$s].clips[$c].start" "$SEGMENT_MAP")
        END=$(jq -r ".sections[$s].clips[$c].end" "$SEGMENT_MAP")
        ROLE=$(jq -r ".sections[$s].clips[$c].role" "$SEGMENT_MAP")
        NARRATION=$(jq -r ".sections[$s].clips[$c].narration" "$SEGMENT_MAP")

        DURATION=$((END - START))
        OUTPUT="$SEGMENTS_DIR/clip-${CLIP_ID}.mp4"
        SCRIPT_FILE="$SCRIPTS_DIR/clip-${CLIP_ID}.txt"

        # Cut video clip if not exists
        if [[ ! -f "$OUTPUT" ]]; then
            ffmpeg -y -ss $START -i "$SOURCE" -t $DURATION \
                -c:v libx264 -preset fast -crf 23 \
                -c:a aac -ar 44100 -ac 2 \
                "$OUTPUT" 2>/dev/null
            echo "  $CLIP_ID: ${START}s-${END}s (${DURATION}s) [$ROLE]"
        fi

        # Write narration script
        echo "$NARRATION" > "$SCRIPT_FILE"
    done
done

echo ""
echo "=== Creating Preview HTML ==="

# Generate HTML
cat > "$SEGMENTS_DIR/index.html" << 'HTMLHEADER'
<!DOCTYPE html>
<html>
<head>
    <title>Favicon Fixes - V2 Preview</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }
        h1 { color: #4CAF50; }
        h2 { color: #ff9800; margin-top: 30px; border-bottom: 1px solid #444; padding-bottom: 10px; }
        .stats { background: #2d2d2d; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .clip { display: flex; margin: 10px 0; padding: 10px; background: #2d2d2d; border-radius: 8px; gap: 15px; border-left: 4px solid #444; }
        .clip.describe { border-left-color: #4CAF50; }
        .clip.joke { border-left-color: #ff9800; }
        .clip.summary { border-left-color: #2196F3; }
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
        .pending { color: #888; font-style: italic; font-size: 12px; margin-top: 8px; }
    </style>
</head>
<body>
    <h1>Favicon Fixes - Narration Preview</h1>
    <div class="stats">
        <strong>Approach:</strong> Two-level segmentation<br>
        <span class="role describe">describe</span> What's happening
        <span class="role joke">joke</span> Commentary
        <span class="role summary">summary</span> Wrap up
    </div>
HTMLHEADER

# Add sections
for s in $(seq 0 $((NUM_SECTIONS - 1))); do
    SECTION_ID=$(jq -r ".sections[$s].id" "$SEGMENT_MAP")
    SECTION_NAME=$(jq -r ".sections[$s].name" "$SEGMENT_MAP")
    SECTION_START=$(jq -r ".sections[$s].start" "$SEGMENT_MAP")
    SECTION_END=$(jq -r ".sections[$s].end" "$SEGMENT_MAP")
    NUM_CLIPS=$(jq ".sections[$s].clips | length" "$SEGMENT_MAP")

    cat >> "$SEGMENTS_DIR/index.html" << SECTIONHTML
    <h2>Section $SECTION_ID: $SECTION_NAME (${SECTION_START}s-${SECTION_END}s)</h2>
SECTIONHTML

    for c in $(seq 0 $((NUM_CLIPS - 1))); do
        CLIP_ID=$(jq -r ".sections[$s].clips[$c].clip_id" "$SEGMENT_MAP")
        START=$(jq -r ".sections[$s].clips[$c].start" "$SEGMENT_MAP")
        END=$(jq -r ".sections[$s].clips[$c].end" "$SEGMENT_MAP")
        ROLE=$(jq -r ".sections[$s].clips[$c].role" "$SEGMENT_MAP")
        NARRATION=$(jq -r ".sections[$s].clips[$c].narration" "$SEGMENT_MAP")
        DURATION=$((END - START))

        AUDIO_FILE="$AUDIO_DIR/clip-${CLIP_ID}.wav"
        if [[ -f "$AUDIO_FILE" ]]; then
            AUDIO_HTML="<audio controls preload=\"metadata\"><source src=\"../../audio/narration/clip-${CLIP_ID}.wav\" type=\"audio/wav\"></audio>"
        else
            AUDIO_HTML="<div class=\"pending\">Audio pending</div>"
        fi

        cat >> "$SEGMENTS_DIR/index.html" << CLIPHTML
    <div class="clip $ROLE">
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

echo "</body></html>" >> "$SEGMENTS_DIR/index.html"

echo "Preview: $SEGMENTS_DIR/index.html"
echo ""
echo "=== Done ==="
echo "Created $(ls "$SEGMENTS_DIR"/clip-*.mp4 2>/dev/null | wc -l | tr -d ' ') clips"
echo "Created $(ls "$SCRIPTS_DIR"/clip-*.txt 2>/dev/null | wc -l | tr -d ' ') scripts"
