#!/bin/bash
# Cut video into segments based on segment-map.json
# Creates clips at logical breakpoints with HTML preview
#
# Usage: ./cut-segments.sh

set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

SEGMENT_MAP="$WORK/segment-map.json"
SEGMENTS_DIR="$WORK/clips/segments"
THUMBS_DIR="$SEGMENTS_DIR/thumbs"

# Check jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install with: brew install jq"
    exit 1
fi

mkdir -p "$SEGMENTS_DIR" "$THUMBS_DIR"

# Read source file from JSON
SOURCE=$(jq -r '.source' "$SEGMENT_MAP")
TOTAL_DURATION=$(jq -r '.total_duration' "$SEGMENT_MAP")
NUM_SEGMENTS=$(jq '.segments | length' "$SEGMENT_MAP")

echo "=== Cutting Video at Logical Breakpoints ==="
echo "Source: $SOURCE"
echo "Duration: ${TOTAL_DURATION}s"
echo "Segments: $NUM_SEGMENTS"
echo "Output: $SEGMENTS_DIR"
echo ""

# Process each segment
for i in $(seq 0 $((NUM_SEGMENTS - 1))); do
    ID=$(jq -r ".segments[$i].id" "$SEGMENT_MAP")
    START=$(jq -r ".segments[$i].start" "$SEGMENT_MAP")
    END=$(jq -r ".segments[$i].end" "$SEGMENT_MAP")
    SUMMARY=$(jq -r ".segments[$i].summary" "$SEGMENT_MAP")

    DURATION=$((END - START))
    PADDED=$(printf "%02d" $ID)
    OUTPUT="$SEGMENTS_DIR/clip-${PADDED}.mp4"
    THUMB="$THUMBS_DIR/clip-${PADDED}.jpg"

    echo "Clip $PADDED: ${START}s-${END}s (${DURATION}s) - $SUMMARY"

    # Extract segment
    ffmpeg -y -ss $START -i "$SOURCE" -t $DURATION \
        -c:v libx264 -preset fast -crf 23 \
        -c:a aac -ar 44100 -ac 2 \
        "$OUTPUT" 2>/dev/null

    # Create thumbnail from middle of segment
    THUMB_TIME=$((START + DURATION / 2))
    ffmpeg -y -ss $THUMB_TIME -i "$SOURCE" -vframes 1 -vf "scale=320:-1" \
        "$THUMB" 2>/dev/null
done

echo ""
echo "Creating HTML preview..."

# Generate HTML
cat > "$SEGMENTS_DIR/index.html" << 'HTMLHEADER'
<!DOCTYPE html>
<html>
<head>
    <title>OBS Segment Preview - Logical Cuts</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }
        h1 { color: #4CAF50; }
        .stats { background: #2d2d2d; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .segment { display: flex; margin: 15px 0; padding: 15px; background: #2d2d2d; border-radius: 8px; gap: 20px; border-left: 4px solid #444; }
        .segment:hover { background: #3d3d3d; border-left-color: #4CAF50; }
        .segment-num { font-size: 28px; font-weight: bold; color: #4CAF50; min-width: 50px; text-align: center; }
        .video-container { flex-shrink: 0; }
        video { width: 560px; border-radius: 4px; }
        .info { flex-grow: 1; display: flex; flex-direction: column; }
        .path { font-family: monospace; font-size: 11px; color: #666; margin-bottom: 5px; }
        .time { color: #ffeb3b; font-size: 14px; margin-bottom: 8px; }
        .duration { color: #888; font-size: 12px; }
        .summary { background: #1a1a1a; padding: 12px; border-radius: 4px; margin-top: 10px; flex-grow: 1; }
        .summary-text { color: #aaa; font-size: 14px; line-height: 1.4; }
        .narration { margin-top: 10px; }
        .narration textarea { width: 100%; height: 60px; background: #252525; color: #fff; border: 1px solid #444; border-radius: 4px; padding: 8px; font-family: inherit; font-size: 13px; resize: vertical; }
        .narration textarea:focus { border-color: #4CAF50; outline: none; }
        .controls { margin-top: 10px; display: flex; gap: 8px; }
        .controls button { padding: 6px 12px; cursor: pointer; border: none; border-radius: 4px; font-size: 12px; }
        .mark-cut { background: #f44336; color: white; }
        .mark-merge { background: #2196F3; color: white; }
        .mark-keep { background: #4CAF50; color: white; }
        .keyboard-help { background: #2d2d2d; padding: 10px 15px; border-radius: 8px; margin-bottom: 20px; font-size: 12px; color: #888; }
        .keyboard-help kbd { background: #444; padding: 2px 6px; border-radius: 3px; margin: 0 3px; }
    </style>
</head>
<body>
    <h1>OBS Segment Preview - Logical Breakpoints</h1>
    <div class="keyboard-help">
        <strong>Keyboard:</strong> <kbd>Space</kbd> Play/Pause | <kbd>J</kbd> Prev clip | <kbd>L</kbd> Next clip | <kbd>K</kbd> Stop | <kbd>1-9</kbd> Jump to clip
    </div>
    <div class="stats">
HTMLHEADER

# Add stats
cat >> "$SEGMENTS_DIR/index.html" << HTMLSTATS
        <strong>Source:</strong> OBS Recording - Favicon Fixes Session<br>
        <strong>Total Duration:</strong> ${TOTAL_DURATION}s (~$((TOTAL_DURATION / 60)) minutes)<br>
        <strong>Segments:</strong> ${NUM_SEGMENTS} clips at logical breakpoints<br>
        <strong>Purpose:</strong> Review clips and add narration text for each segment
    </div>
HTMLSTATS

# Add each segment
for i in $(seq 0 $((NUM_SEGMENTS - 1))); do
    ID=$(jq -r ".segments[$i].id" "$SEGMENT_MAP")
    START=$(jq -r ".segments[$i].start" "$SEGMENT_MAP")
    END=$(jq -r ".segments[$i].end" "$SEGMENT_MAP")
    SUMMARY=$(jq -r ".segments[$i].summary" "$SEGMENT_MAP")

    DURATION=$((END - START))
    PADDED=$(printf "%02d" $ID)

    cat >> "$SEGMENTS_DIR/index.html" << HTMLSEG
    <div class="segment" id="clip-${PADDED}" data-id="${ID}">
        <div class="segment-num">${ID}</div>
        <div class="video-container">
            <video controls preload="metadata" id="video-${ID}">
                <source src="clip-${PADDED}.mp4" type="video/mp4">
            </video>
        </div>
        <div class="info">
            <div class="path">clips/segments/clip-${PADDED}.mp4</div>
            <div class="time">${START}s - ${END}s <span class="duration">(${DURATION}s)</span></div>
            <div class="summary">
                <div class="summary-text">${SUMMARY}</div>
                <div class="narration">
                    <textarea placeholder="Add narration script for this clip..."></textarea>
                </div>
            </div>
            <div class="controls">
                <button class="mark-keep" onclick="markClip(this, 'keep')">Keep</button>
                <button class="mark-cut" onclick="markClip(this, 'cut')">Cut</button>
                <button class="mark-merge" onclick="markClip(this, 'merge')">Merge Next</button>
            </div>
        </div>
    </div>
HTMLSEG
done

# Close HTML with JavaScript
cat >> "$SEGMENTS_DIR/index.html" << 'HTMLFOOTER'
    <script>
        let currentClip = 1;
        const videos = document.querySelectorAll('video');
        const totalClips = videos.length;

        function playClip(n) {
            if (n < 1 || n > totalClips) return;
            videos.forEach(v => v.pause());
            currentClip = n;
            const video = document.getElementById('video-' + n);
            video.scrollIntoView({behavior: 'smooth', block: 'center'});
            setTimeout(() => video.play(), 300);
        }

        function markClip(btn, action) {
            const segment = btn.closest('.segment');
            segment.style.borderLeftColor = action === 'keep' ? '#4CAF50' :
                                            action === 'cut' ? '#f44336' : '#2196F3';
            segment.style.opacity = action === 'cut' ? '0.4' : '1';
        }

        document.addEventListener('keydown', (e) => {
            if (e.target.tagName === 'TEXTAREA') return;
            switch(e.key) {
                case ' ':
                    e.preventDefault();
                    const v = document.getElementById('video-' + currentClip);
                    v.paused ? v.play() : v.pause();
                    break;
                case 'j': playClip(currentClip - 1); break;
                case 'l': playClip(currentClip + 1); break;
                case 'k': videos.forEach(v => v.pause()); break;
                default:
                    if (e.key >= '1' && e.key <= '9') playClip(parseInt(e.key));
            }
        });

        // Auto-advance to next clip when current one ends
        videos.forEach((v, i) => {
            v.addEventListener('ended', () => playClip(i + 2));
        });
    </script>
</body>
</html>
HTMLFOOTER

echo ""
echo "=== Done ==="
echo "Preview: $SEGMENTS_DIR/index.html"
echo ""
echo "Open in browser: open '$SEGMENTS_DIR/index.html'"
