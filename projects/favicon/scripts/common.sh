#!/bin/bash
# Common variables for favicon video production scripts

TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/favicon"

ASSETS="$PROJECT/assets"
WORK="$PROJECT/work"
CLIPS="$WORK/clips"
AUDIO="$WORK/audio"
STILLS="$WORK/stills"
AVATAR="$WORK/avatar"
SCRIPTS="$WORK/scripts"

MUSIC="$REFDIR/music/soaring.mp3"

# Project-specific avatar
AVATAR_SOURCE="$ASSETS/videos/curmudgeon.mp4"

# Tools
VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
VID_VOLUME="$TOOLS/vid-volume"
VID_SCALE="$TOOLS/vid-scale"
