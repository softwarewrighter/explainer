#!/bin/bash
# Common variables for rlm-war-and-peace-demo video production scripts
# Project: RLM War and Peace Demo Explainer Video

TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/rlm-war-and-peace-demo"

ASSETS="$PROJECT/assets"
WORK="$PROJECT/work"
CLIPS="$WORK/clips"
AUDIO="$WORK/audio"
STILLS="$WORK/stills"
AVATAR="$WORK/avatar"
SCRIPTS="$WORK/scripts"

# Music: Restless Heart by Jimena Contreras
MUSIC="$REFDIR/music/Restless Heart - Jimena Contreras.mp3"

# Avatar: curmudgeon (default presenter)
AVATAR_SOURCE="$ASSETS/videos/curmudgeon.mp4"

# VHS demo video (charmbracelet/vhs)
VHS_SOURCE="$ASSETS/videos/war-and-peace-demo.mp4"

# Tools
VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
VID_VOLUME="$TOOLS/vid-volume"
VID_SCALE="$TOOLS/vid-scale"
