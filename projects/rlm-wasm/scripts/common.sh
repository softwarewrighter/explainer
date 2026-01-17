#!/bin/bash
# Common variables for rlm-wasm video project

TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/rlm-wasm"

ASSETS="$PROJECT/assets"
WORK="$PROJECT/work"
CLIPS="$WORK/clips"
AUDIO="$WORK/audio"
STILLS="$WORK/stills"
SVG="$WORK/svg"
VHS="$WORK/vhs"
AVATAR="$WORK/avatar"

MUSIC="$REFDIR/music/All In - Everet Almond.mp3"

# Avatar source
AVATAR_SOURCE="$REFDIR/curmudgeon.mp4"

# Video tools
VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_CONCAT="$TOOLS/vid-concat"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_AVATAR="$TOOLS/vid-avatar"
VID_VOLUME="$TOOLS/vid-volume"
VID_SCALE="$TOOLS/vid-scale"
VID_MUSIC="$TOOLS/vid-music"
