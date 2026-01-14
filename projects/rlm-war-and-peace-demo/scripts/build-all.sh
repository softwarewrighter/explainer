#!/bin/bash
# Master build script for rolodex video
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
    echo "Rolodex Video Production Pipeline"
    echo ""
    echo "Usage: $0 <step>"
    echo ""
    echo "Steps:"
    echo "  tts      - Generate TTS audio for all scripts"
    echo "  slides   - Build all slide clips (SVG + audio, no avatar)"
    echo "  avatar   - Build avatar-composited clips (02-hook, XX-cta)"
    echo "  title    - Build title clip with music"
    echo "  epilog   - Build epilog extension clip"
    echo "  concat   - Concatenate all clips into draft"
    echo "  all      - Run all steps in order"
    echo ""
    echo "Individual clip scripts:"
    echo "  ./generate-tts.sh <name>       - Generate TTS for one script"
    echo "  ./build-slide.sh <name>        - Build one slide clip"
    echo "  ./build-avatar-clip.sh <name>  - Build one avatar clip"
    echo "  ./build-title.sh               - Build title clip"
    echo "  ./build-epilog.sh              - Build epilog extension"
    echo "  ./boost-volume.sh <clip> <db>  - Boost clip volume"
    echo "  ./check-levels.sh              - Check all clip audio levels"
}

step_tts() {
    echo "=== Step: Generate TTS Audio ==="
    for script in "$WORK/scripts"/*.txt; do
        if [ -f "$script" ]; then
            NAME=$(basename "$script" .txt)
            echo "Generating: $NAME"
            "$SCRIPT_DIR/generate-tts.sh" "$NAME"
        fi
    done
}

step_slides() {
    echo "=== Step: Build Slide Clips ==="
    # All narrated slides that don't need avatar overlay
    # TODO: Add slide names here as they are created
    SLIDES=(
        # 03-problem
        # 04-solution
        # etc.
    )
    for NAME in "${SLIDES[@]}"; do
        echo "Building: $NAME"
        "$SCRIPT_DIR/build-slide.sh" "$NAME"
    done

    if [ ${#SLIDES[@]} -eq 0 ]; then
        echo "No slides defined yet. Add slide names to build-all.sh step_slides()"
    fi
}

step_avatar() {
    echo "=== Step: Build Avatar Clips ==="
    # TODO: Update with actual hook and CTA segment names
    # Clips with lip-synced avatar overlay
    for NAME in 02-hook XX-cta; do
        echo "Building avatar clip: $NAME"
        "$SCRIPT_DIR/build-avatar-clip.sh" "$NAME"
    done
}

step_title() {
    echo "=== Step: Build Title Clip ==="
    "$SCRIPT_DIR/build-title.sh"
}

step_epilog() {
    echo "=== Step: Build Epilog Clip ==="
    "$SCRIPT_DIR/build-epilog.sh"
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
