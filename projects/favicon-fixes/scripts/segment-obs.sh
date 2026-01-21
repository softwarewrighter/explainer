#!/bin/bash
# Segment OBS recording into clips for narration
# Creates clips at specified intervals and builds an HTML preview
#
# Usage: ./segment-obs.sh <input.mp4> <segment_seconds>
# Default segment: 10 seconds

set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

INPUT="${1:-/Users/mike/Movies/2026-01-09 19-45-36.mp4}"
SEGMENT_DURATION="${2:-10}"
SEGMENTS_DIR="$WORK/clips/segments"
THUMBS_DIR="$SEGMENTS_DIR/thumbs"

mkdir -p "$SEGMENTS_DIR" "$THUMBS_DIR"

# Get video duration
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$INPUT")
DURATION_INT=${DURATION%.*}

echo "=== Segmenting OBS Recording ==="
echo "Input: $INPUT"
echo "Duration: ${DURATION_INT}s"
echo "Segment length: ${SEGMENT_DURATION}s"
echo "Output: $SEGMENTS_DIR"
echo ""

# Calculate number of segments
NUM_SEGMENTS=$((DURATION_INT / SEGMENT_DURATION + 1))
echo "Creating ~$NUM_SEGMENTS segments..."
echo ""

# Create segments
SEGMENT_NUM=1
START=0

while [ $START -lt $DURATION_INT ]; do
    PADDED=$(printf "%03d" $SEGMENT_NUM)
    OUTPUT="$SEGMENTS_DIR/segment-${PADDED}.mp4"
    THUMB="$THUMBS_DIR/segment-${PADDED}.jpg"

    # Extract segment
    ffmpeg -y -ss $START -i "$INPUT" -t $SEGMENT_DURATION \
        -c:v libx264 -preset fast -crf 23 \
        -c:a aac -ar 44100 -ac 2 \
        "$OUTPUT" 2>/dev/null

    # Create thumbnail from middle of segment
    THUMB_TIME=$((START + SEGMENT_DURATION / 2))
    ffmpeg -y -ss $THUMB_TIME -i "$INPUT" -vframes 1 -vf "scale=320:-1" \
        "$THUMB" 2>/dev/null

    # Get actual duration of this segment
    SEG_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT" 2>/dev/null || echo "0")

    printf "Segment %03d: %ds - %ds (%.1fs)\n" $SEGMENT_NUM $START $((START + SEGMENT_DURATION)) "$SEG_DUR"

    START=$((START + SEGMENT_DURATION))
    SEGMENT_NUM=$((SEGMENT_NUM + 1))
done

echo ""
echo "Created $((SEGMENT_NUM - 1)) segments"
echo ""

# Now build the HTML preview
echo "Building HTML preview..."

cat > "$SEGMENTS_DIR/index.html" << 'HTMLHEADER'
<!DOCTYPE html>
<html>
<head>
    <title>OBS Segment Preview</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }
        h1 { color: #4CAF50; }
        .segment { display: flex; margin: 20px 0; padding: 15px; background: #2d2d2d; border-radius: 8px; gap: 20px; }
        .segment:hover { background: #3d3d3d; }
        .segment-num { font-size: 24px; font-weight: bold; color: #4CAF50; min-width: 60px; }
        .video-container { flex-shrink: 0; }
        video { width: 480px; border-radius: 4px; }
        .info { flex-grow: 1; }
        .path { font-family: monospace; font-size: 12px; color: #888; margin-bottom: 10px; }
        .time { color: #ffeb3b; margin-bottom: 10px; }
        .summary { background: #1a1a1a; padding: 10px; border-radius: 4px; min-height: 60px; }
        .summary textarea { width: 100%; height: 80px; background: #1a1a1a; color: #fff; border: 1px solid #444; border-radius: 4px; padding: 8px; font-family: inherit; }
        .controls { margin-top: 10px; }
        .controls button { padding: 5px 15px; margin-right: 10px; cursor: pointer; }
        .mark-cut { background: #f44336; color: white; border: none; border-radius: 4px; }
        .mark-merge { background: #2196F3; color: white; border: none; border-radius: 4px; }
        .stats { background: #2d2d2d; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <h1>OBS Segment Preview</h1>
    <div class="stats">
        <strong>Source:</strong> OBS Recording<br>
HTMLHEADER

# Add stats to HTML
cat >> "$SEGMENTS_DIR/index.html" << HTMLSTATS
        <strong>Total Duration:</strong> ${DURATION_INT}s (~$((DURATION_INT / 60)) minutes)<br>
        <strong>Segments:</strong> $((SEGMENT_NUM - 1)) clips @ ${SEGMENT_DURATION}s each<br>
        <strong>Target:</strong> 7-12 second clips for narration
    </div>
HTMLSTATS

# Add each segment to HTML
for i in $(seq 1 $((SEGMENT_NUM - 1))); do
    PADDED=$(printf "%03d" $i)
    START_TIME=$(( (i - 1) * SEGMENT_DURATION ))
    END_TIME=$((START_TIME + SEGMENT_DURATION))

    cat >> "$SEGMENTS_DIR/index.html" << HTMLSEG
    <div class="segment" id="seg-${PADDED}">
        <div class="segment-num">#${PADDED}</div>
        <div class="video-container">
            <video controls preload="metadata">
                <source src="segment-${PADDED}.mp4" type="video/mp4">
            </video>
        </div>
        <div class="info">
            <div class="path">segments/segment-${PADDED}.mp4</div>
            <div class="time">${START_TIME}s - ${END_TIME}s</div>
            <div class="summary">
                <textarea placeholder="Describe what happens in this segment..."></textarea>
            </div>
            <div class="controls">
                <button class="mark-cut" onclick="this.parentElement.parentElement.style.opacity='0.3'">Mark for Cut</button>
                <button class="mark-merge" onclick="this.parentElement.parentElement.style.borderLeft='4px solid #2196F3'">Merge with Next</button>
            </div>
        </div>
    </div>
HTMLSEG
done

# Close HTML
cat >> "$SEGMENTS_DIR/index.html" << 'HTMLFOOTER'
    <script>
        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            const videos = document.querySelectorAll('video');
            if (e.key === 'ArrowRight') {
                // Find currently playing and play next
                for (let i = 0; i < videos.length - 1; i++) {
                    if (!videos[i].paused) {
                        videos[i].pause();
                        videos[i+1].play();
                        videos[i+1].scrollIntoView({behavior: 'smooth', block: 'center'});
                        break;
                    }
                }
            }
        });
    </script>
</body>
</html>
HTMLFOOTER

echo "Preview created: $SEGMENTS_DIR/index.html"
echo ""
echo "=== Done ==="
