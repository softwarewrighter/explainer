#!/bin/bash
# Build preview video with burnt-in captions (no TTS)
# Usage: ./build-preview.sh

set -e
cd /Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs

VID_IMAGE=~/github/softwarewrighter/video-publishing/tools/target/release/vid-image
VID_CONCAT=~/github/softwarewrighter/video-publishing/tools/target/release/vid-concat

# Font settings for captions
FONT="/System/Library/Fonts/Helvetica.ttc"
FONTSIZE=42
FONTCOLOR="white"
BOXCOLOR="black@0.7"
MARGIN=40

# Create clips with captions
create_captioned_clip() {
    local img=$1
    local duration=$2
    local caption=$3
    local output=$4

    # Escape special characters for drawtext
    caption=$(echo "$caption" | sed "s/'/\\\\\\'/g" | sed 's/:/\\:/g')

    ffmpeg -y -loop 1 -i "$img" -t "$duration" \
        -vf "drawtext=fontfile=$FONT:fontsize=$FONTSIZE:fontcolor=$FONTCOLOR:x=(w-text_w)/2:y=h-$MARGIN-text_h:text='$caption':box=1:boxcolor=$BOXCOLOR:boxborderw=10" \
        -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 \
        "$output" 2>/dev/null
    echo "Created: $output"
}

# Create clips with multiline captions (for longer text)
create_multiline_clip() {
    local img=$1
    local duration=$2
    local line1=$3
    local line2=$4
    local output=$5

    line1=$(echo "$line1" | sed "s/'/\\\\\\'/g" | sed 's/:/\\:/g')
    line2=$(echo "$line2" | sed "s/'/\\\\\\'/g" | sed 's/:/\\:/g')

    ffmpeg -y -loop 1 -i "$img" -t "$duration" \
        -vf "drawtext=fontfile=$FONT:fontsize=$FONTSIZE:fontcolor=$FONTCOLOR:x=(w-text_w)/2:y=h-$MARGIN-text_h*2-20:text='$line1':box=1:boxcolor=$BOXCOLOR:boxborderw=10,drawtext=fontfile=$FONT:fontsize=$FONTSIZE:fontcolor=$FONTCOLOR:x=(w-text_w)/2:y=h-$MARGIN-text_h:text='$line2':box=1:boxcolor=$BOXCOLOR:boxborderw=10" \
        -c:v libx264 -crf 18 -pix_fmt yuv420p -r 30 \
        "$output" 2>/dev/null
    echo "Created: $output"
}

# Add caption to existing video
add_caption_to_video() {
    local video=$1
    local caption=$2
    local output=$3

    caption=$(echo "$caption" | sed "s/'/\\\\\\'/g" | sed 's/:/\\:/g')

    ffmpeg -y -i "$video" \
        -vf "drawtext=fontfile=$FONT:fontsize=$FONTSIZE:fontcolor=$FONTCOLOR:x=(w-text_w)/2:y=h-$MARGIN-text_h:text='$caption':box=1:boxcolor=$BOXCOLOR:boxborderw=10" \
        -c:v libx264 -crf 18 -c:a copy \
        "$output" 2>/dev/null
    echo "Created: $output"
}

echo "=== Building TBT4-TT-RS Preview Video ==="
echo ""

# 01 - Hook (15s - just showing the overview slide)
create_multiline_clip "work/stills/01-hook.png" 15 \
    "tt-rs is a visual programming environment." \
    "Three levels introduce the concepts." \
    "work/clips/01-hook-captioned.mp4"

# 02 - tt1 Intro (10s)
create_multiline_clip "work/stills/02-tt1-intro.png" 10 \
    "Level one introduces the basics." \
    "Four tutorials walk you through the core concepts." \
    "work/clips/02-tt1-intro-captioned.mp4"

# 05 - Fill the Box Intro (8s)
create_multiline_clip "work/stills/05-fill-the-box-intro.png" 8 \
    "First tutorial: fill the box." \
    "Drag numbers into empty holes." \
    "work/clips/05-fill-the-box-intro-captioned.mp4"

# 05d - Fill the Box Demo (existing OBS clip, add caption)
if [ -f "work/clips/05d-fill-the-box-demo-raw.mp4" ]; then
    add_caption_to_video "work/clips/05d-fill-the-box-demo-raw.mp4" \
        "Fill all three holes to complete the box." \
        "work/clips/05d-fill-the-box-demo-captioned.mp4"
fi

# 06 - Add Numbers Intro (8s)
create_multiline_clip "work/stills/06-add-numbers-intro.png" 8 \
    "Next: adding numbers." \
    "Drag one number onto another to combine them." \
    "work/clips/06-add-numbers-intro-captioned.mp4"

# 06d - Add Numbers Demo (existing OBS clip, add caption)
if [ -f "work/clips/06d-add-numbers-demo-raw.mp4" ]; then
    add_caption_to_video "work/clips/06d-add-numbers-demo-raw.mp4" \
        "Arithmetic happens when widgets touch." \
        "work/clips/06d-add-numbers-demo-captioned.mp4"
fi

# 99 - CTA (12s)
create_multiline_clip "work/stills/99-cta.png" 12 \
    "Try it yourself. Link in description." \
    "This is a Throwback Thursday project." \
    "work/clips/99-cta-captioned.mp4"

echo ""
echo "=== Creating concat list ==="

# Create concat list
cat > work/clips/preview-concat.txt << 'EOF'
/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips/01-hook-captioned.mp4
/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips/02-tt1-intro-captioned.mp4
/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips/05-fill-the-box-intro-captioned.mp4
/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips/05d-fill-the-box-demo-captioned.mp4
/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips/06-add-numbers-intro-captioned.mp4
/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips/06d-add-numbers-demo-captioned.mp4
/Users/mike/github/softwarewrighter/explainer/projects/tbt4-tt-rs/work/clips/99-cta-captioned.mp4
EOF

echo "Concat list created"
echo ""
echo "=== Concatenating clips ==="

# Concatenate with vid-concat
$VID_CONCAT --list work/clips/preview-concat.txt --output work/clips/preview-draft.mp4 --reencode

echo ""
echo "=== Preview video created ==="
echo "Output: work/clips/preview-draft.mp4"
ffprobe -v error -show_entries format=duration -of csv=p=0 work/clips/preview-draft.mp4 | xargs printf "Duration: %.1f seconds\n"
