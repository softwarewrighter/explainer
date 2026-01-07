#!/bin/bash
# Master build script for babyai-hrm video
# Documents all production steps in order
#
# Usage: ./build-all.sh [step]
# Steps: tts, slides, avatar, title, epilog, concat, all
#
# This script serves as documentation of the full pipeline.
# Run individual steps or 'all' for complete rebuild.

set -e
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

STEP="${1:-help}"

show_help() {
    echo "babyai-hrm Video Production Pipeline"
    echo ""
    echo "Usage: $0 <step>"
    echo ""
    echo "Steps:"
    echo "  tts      - Generate TTS audio for all scripts"
    echo "  slides   - Build all slide clips (SVG + audio)"
    echo "  avatar   - Build avatar-composited clips (02-hook, 29-cta)"
    echo "  title    - Build title clip with music"
    echo "  epilog   - Copy and boost epilog clips"
    echo "  concat   - Concatenate all clips into draft"
    echo "  all      - Run all steps in order"
    echo ""
    echo "Individual clip scripts:"
    echo "  ./generate-tts.sh <name>       - Generate TTS for one script"
    echo "  ./build-slide.sh <name>        - Build one slide clip"
    echo "  ./build-avatar-clip.sh <name>  - Build one avatar clip"
    echo "  ./boost-volume.sh <clip> <db>  - Boost clip volume"
    echo "  ./scale-clip.sh <clip>         - Scale clip to 1920x1080"
    echo "  ./check-levels.sh              - Check all clip audio levels"
}

step_tts() {
    echo "=== Step: Generate TTS Audio ==="
    for script in "$WORK/scripts"/*.txt; do
        NAME=$(basename "$script" .txt)
        echo "Generating: $NAME"
        "$SCRIPT_DIR/generate-tts.sh" "$NAME"
    done
}

step_slides() {
    echo "=== Step: Build Slide Clips ==="
    # All narrated slides (not title, not avatar clips)
    SLIDES=(
        03-problem 04-solution 05-preview
        06-task-intro 07-task-goal 08-task-untrained 09-task-trained
        10-hierarchy-why 11-planner-doer 12-planner-role 13-doer-role
        14-hrm-vs-llm 15-tradeoff 16-trm-evolution
        17-viz-overview 18-training-data 19-learning-process 20-thought-bubbles 21-before-after
        22-tutorial-mode 23-freeplay-mode 24-metrics
        25-recap-task 26-recap-hrm 27-recap-viz 28-key-insight
    )
    for NAME in "${SLIDES[@]}"; do
        echo "Building: $NAME"
        "$SCRIPT_DIR/build-slide.sh" "$NAME"
    done
}

step_avatar() {
    echo "=== Step: Build Avatar Clips ==="
    # Clips with lip-synced avatar overlay
    for NAME in 02-hook 29-cta; do
        echo "Building avatar clip: $NAME"
        "$SCRIPT_DIR/build-avatar-clip.sh" "$NAME"
    done
}

step_title() {
    echo "=== Step: Build Title Clip ==="
    "$SCRIPT_DIR/build-title.sh"

    # Check if boosting is needed
    MEAN=$($VID_VOLUME --input "$CLIPS/01-title.mp4" --print-levels 2>&1 | grep "Mean volume" | awk '{print $3}' | tr -d '-')
    if (( $(echo "$MEAN > 35" | bc -l) )); then
        echo "Title is quiet, boosting by 15dB..."
        "$SCRIPT_DIR/boost-volume.sh" 01-title.mp4 15 01-title-boosted.mp4
    fi
}

step_epilog() {
    echo "=== Step: Prepare Epilog Clips ==="

    # Copy epilog clips from reference
    cp "$REFDIR/epilog/99b-epilog.mp4" "$CLIPS/"
    cp "$REFDIR/epilog/99c-epilog-ext.mp4" "$CLIPS/"

    # Boost epilog clips (they use same music as title)
    "$SCRIPT_DIR/boost-volume.sh" 99b-epilog.mp4 15 99b-epilog-boosted.mp4
    "$SCRIPT_DIR/boost-volume.sh" 99c-epilog-ext.mp4 15 99c-epilog-ext-boosted.mp4
}

step_concat() {
    echo "=== Step: Concatenate Draft ==="
    "$SCRIPT_DIR/concat-draft.sh"
}

case "$STEP" in
    help)
        show_help
        ;;
    tts)
        step_tts
        ;;
    slides)
        step_slides
        ;;
    avatar)
        step_avatar
        ;;
    title)
        step_title
        ;;
    epilog)
        step_epilog
        ;;
    concat)
        step_concat
        ;;
    all)
        step_tts
        step_slides
        step_avatar
        step_title
        step_epilog
        step_concat
        echo ""
        echo "=== Build Complete ==="
        "$SCRIPT_DIR/check-levels.sh"
        ;;
    *)
        echo "Unknown step: $STEP"
        show_help
        exit 1
        ;;
esac
