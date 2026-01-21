#!/bin/bash
# Update the HTML preview with narration drafts
set -e

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

NARRATION_FILE="$WORK/scripts/narration-draft.txt"
HTML_FILE="$WORK/clips/segments/index.html"

# Create a new HTML with narration included
cat > "$WORK/clips/segments/index.html" << 'HTMLHEADER'
<!DOCTYPE html>
<html>
<head>
    <title>OBS Segment Preview - With Narration</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }
        h1 { color: #4CAF50; }
        .stats { background: #2d2d2d; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .segment { display: flex; margin: 15px 0; padding: 15px; background: #2d2d2d; border-radius: 8px; gap: 20px; border-left: 4px solid #444; }
        .segment:hover { background: #3d3d3d; border-left-color: #4CAF50; }
        .segment.reviewed { border-left-color: #4CAF50; }
        .segment.needs-edit { border-left-color: #ff9800; }
        .segment-num { font-size: 28px; font-weight: bold; color: #4CAF50; min-width: 50px; text-align: center; }
        .video-container { flex-shrink: 0; }
        video { width: 480px; border-radius: 4px; }
        .info { flex-grow: 1; display: flex; flex-direction: column; }
        .path { font-family: monospace; font-size: 11px; color: #666; margin-bottom: 5px; }
        .time { color: #ffeb3b; font-size: 14px; margin-bottom: 8px; }
        .duration { color: #888; font-size: 12px; }
        .summary { background: #1a1a1a; padding: 12px; border-radius: 4px; margin-top: 8px; }
        .summary-label { color: #666; font-size: 11px; text-transform: uppercase; margin-bottom: 4px; }
        .summary-text { color: #888; font-size: 13px; line-height: 1.4; }
        .narration { margin-top: 8px; }
        .narration-label { color: #4CAF50; font-size: 11px; text-transform: uppercase; margin-bottom: 4px; font-weight: bold; }
        .narration textarea { width: 100%; height: 70px; background: #252525; color: #fff; border: 1px solid #444; border-radius: 4px; padding: 8px; font-family: inherit; font-size: 14px; resize: vertical; line-height: 1.5; }
        .narration textarea:focus { border-color: #4CAF50; outline: none; }
        .char-count { font-size: 11px; color: #666; text-align: right; margin-top: 2px; }
        .char-count.warning { color: #ff9800; }
        .char-count.error { color: #f44336; }
        .controls { margin-top: 10px; display: flex; gap: 8px; align-items: center; }
        .controls button { padding: 6px 12px; cursor: pointer; border: none; border-radius: 4px; font-size: 12px; }
        .mark-ok { background: #4CAF50; color: white; }
        .mark-edit { background: #ff9800; color: white; }
        .mark-skip { background: #666; color: white; }
        .keyboard-help { background: #2d2d2d; padding: 10px 15px; border-radius: 8px; margin-bottom: 20px; font-size: 12px; color: #888; }
        .keyboard-help kbd { background: #444; padding: 2px 6px; border-radius: 3px; margin: 0 3px; }
        .export-btn { background: #2196F3; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <h1>Favicon Fixes - Narration Review</h1>
    <button class="export-btn" onclick="exportNarration()">Export All Narration</button>
    <div class="keyboard-help">
        <strong>Keyboard:</strong> <kbd>Space</kbd> Play/Pause | <kbd>J</kbd> Prev | <kbd>L</kbd> Next | <kbd>Enter</kbd> Mark OK | <kbd>E</kbd> Mark needs edit
    </div>
    <div class="stats">
        <strong>Total Clips:</strong> 58 | <strong>Duration:</strong> ~40 minutes<br>
        <strong>Instructions:</strong> Review each clip's narration. Edit text as needed, then mark as OK or needs edit.
    </div>
HTMLHEADER

# Read segment map and narration, generate HTML for each clip
SEGMENT_MAP="$WORK/segment-map.json"
NUM_SEGMENTS=$(jq '.segments | length' "$SEGMENT_MAP")

for i in $(seq 0 $((NUM_SEGMENTS - 1))); do
    ID=$(jq -r ".segments[$i].id" "$SEGMENT_MAP")
    START=$(jq -r ".segments[$i].start" "$SEGMENT_MAP")
    END=$(jq -r ".segments[$i].end" "$SEGMENT_MAP")
    SUMMARY=$(jq -r ".segments[$i].summary" "$SEGMENT_MAP")

    DURATION=$((END - START))
    PADDED=$(printf "%02d" $ID)

    # Get narration from file
    NARRATION=$(grep "^${PADDED}:" "$NARRATION_FILE" 2>/dev/null | sed "s/^${PADDED}: //" || echo "")

    cat >> "$HTML_FILE" << HTMLSEG
    <div class="segment" id="clip-${PADDED}" data-id="${ID}">
        <div class="segment-num">${ID}</div>
        <div class="video-container">
            <video controls preload="metadata" id="video-${ID}">
                <source src="clip-${PADDED}.mp4" type="video/mp4">
            </video>
        </div>
        <div class="info">
            <div class="path">clip-${PADDED}.mp4 | ${START}s - ${END}s <span class="duration">(${DURATION}s)</span></div>
            <div class="summary">
                <div class="summary-label">What happens</div>
                <div class="summary-text">${SUMMARY}</div>
            </div>
            <div class="narration">
                <div class="narration-label">Narration Script</div>
                <textarea id="narration-${ID}" oninput="updateCharCount(${ID})">${NARRATION}</textarea>
                <div class="char-count" id="chars-${ID}"></div>
            </div>
            <div class="controls">
                <button class="mark-ok" onclick="markClip(${ID}, 'ok')">OK</button>
                <button class="mark-edit" onclick="markClip(${ID}, 'edit')">Needs Edit</button>
                <button class="mark-skip" onclick="markClip(${ID}, 'skip')">Skip Clip</button>
            </div>
        </div>
    </div>
HTMLSEG
done

# Add JavaScript
cat >> "$HTML_FILE" << 'HTMLFOOTER'
    <script>
        let currentClip = 1;
        const totalClips = 58;

        // Initialize char counts
        for (let i = 1; i <= totalClips; i++) {
            updateCharCount(i);
        }

        function updateCharCount(id) {
            const textarea = document.getElementById('narration-' + id);
            const counter = document.getElementById('chars-' + id);
            const len = textarea.value.length;
            counter.textContent = len + ' chars';
            counter.className = 'char-count' + (len > 200 ? ' error' : len > 150 ? ' warning' : '');
        }

        function markClip(id, status) {
            const segment = document.getElementById('clip-' + String(id).padStart(2, '0'));
            segment.className = 'segment ' + (status === 'ok' ? 'reviewed' : status === 'edit' ? 'needs-edit' : '');
            if (status === 'skip') segment.style.opacity = '0.4';
            // Auto-advance
            playClip(id + 1);
        }

        function playClip(n) {
            if (n < 1 || n > totalClips) return;
            document.querySelectorAll('video').forEach(v => v.pause());
            currentClip = n;
            const video = document.getElementById('video-' + n);
            video.scrollIntoView({behavior: 'smooth', block: 'center'});
            setTimeout(() => video.play(), 300);
        }

        function exportNarration() {
            let output = '# Narration Scripts - Reviewed\\n\\n';
            for (let i = 1; i <= totalClips; i++) {
                const text = document.getElementById('narration-' + i).value;
                output += String(i).padStart(2, '0') + ': ' + text + '\\n';
            }
            const blob = new Blob([output], {type: 'text/plain'});
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'narration-reviewed.txt';
            a.click();
        }

        document.addEventListener('keydown', (e) => {
            if (e.target.tagName === 'TEXTAREA') {
                if (e.key === 'Escape') e.target.blur();
                return;
            }
            switch(e.key) {
                case ' ': e.preventDefault();
                    const v = document.getElementById('video-' + currentClip);
                    v.paused ? v.play() : v.pause(); break;
                case 'j': playClip(currentClip - 1); break;
                case 'l': playClip(currentClip + 1); break;
                case 'Enter': markClip(currentClip, 'ok'); break;
                case 'e': markClip(currentClip, 'edit'); break;
            }
        });

        document.querySelectorAll('video').forEach((v, i) => {
            v.addEventListener('ended', () => playClip(i + 2));
        });
    </script>
</body>
</html>
HTMLFOOTER

echo "Updated HTML with narration drafts: $HTML_FILE"
