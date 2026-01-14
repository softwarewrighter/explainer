#!/bin/bash
# Common variables for rolodex video production scripts
# Project: Rolodex Explainer Video

TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/rolodex"

ASSETS="$PROJECT/assets"
WORK="$PROJECT/work"
CLIPS="$WORK/clips"
AUDIO="$WORK/audio"
STILLS="$WORK/stills"
AVATAR="$WORK/avatar"
SCRIPTS="$WORK/scripts"

# Music: The Throne by Silent Partner
MUSIC="$REFDIR/music/The Throne - Silent Partner.mp3"

# Avatar: curmudgeon (same as favicon-fixes)
AVATAR_SOURCE="$ASSETS/videos/curmudgeon.mp4"

# OBS source video
OBS_SOURCE="/Users/mike/Movies/2026-01-11 16-11-23.mp4"

# Tools
VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
VID_VOLUME="$TOOLS/vid-volume"
VID_SCALE="$TOOLS/vid-scale"
