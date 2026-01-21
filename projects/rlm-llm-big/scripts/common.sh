#!/bin/bash
# Common variables for rlm-llm-big video production scripts
# Project: RLM Level 4 LLM Demo - War and Peace Family Tree

TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/rlm-llm-big"

ASSETS="$PROJECT/assets"
WORK="$PROJECT/work"
CLIPS="$WORK/clips"
AUDIO="$WORK/audio"
STILLS="$WORK/stills"
AVATAR="$WORK/avatar"
NARRATION="$WORK/scripts"
VHS_DIR="$WORK/vhs"

MUSIC="$REFDIR/music/Two Gong Fire - Ryan McCaffrey_Go By Ocean.mp3"

# Curmudgeon avatar for this project
AVATAR_SOURCE="$REFDIR/curmudgeon.mp4"

# VHS demo recording
VHS_SOURCE="$VHS_DIR/family-tree-demo.mp4"

# Tools
VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
VID_VOLUME="$TOOLS/vid-volume"
VID_SCALE="$TOOLS/vid-scale"
VID_SPEEDUP="$TOOLS/vid-speedup"

# Ensure directories exist
mkdir -p "$CLIPS" "$AUDIO" "$STILLS" "$AVATAR"
