set dotenv-load := true

# ============================================================================
# Configuration
# ============================================================================

FPS := "30"
WIDTH := "1920"
HEIGHT := "1080"
BASE_URL := "http://127.0.0.1:4173"

# Video pipeline tools from video-publishing
TOOLS := "/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR := "/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR := "/Users/mike/github/softwarewrighter/explainer/work"
MUSIC := REFDIR + "/music/swing9.mp3"

VID_TTS := TOOLS + "/vid-tts"
VID_AVATAR := TOOLS + "/vid-avatar"
VID_LIPSYNC := TOOLS + "/vid-lipsync"
VID_COMPOSITE := TOOLS + "/vid-composite"
VID_CONCAT := TOOLS + "/vid-concat"
VID_REVIEW := TOOLS + "/vid-review"

# ============================================================================
# Web Renderer (Playwright Frame Capture)
# ============================================================================

# Build the Yew/WASM web renderer
web-build:
	cd explainer_web && trunk build --release

# Serve the web renderer for development
web-serve:
	cd explainer_web && trunk serve --port 4173

# Install Playwright and browsers
playwright-install:
	cd scripts && npm install && npx playwright install --with-deps

# Generate render plan from scenes.yaml
render-plan:
	cargo run -p explainerctl -- render-plan

# Capture frames using Playwright (headless Chromium)
frames: web-build playwright-install render-plan
	cd scripts && node capture_frames.mjs --base-url {{BASE_URL}} --fps {{FPS}}

# ============================================================================
# Audio Generation (TTS)
# ============================================================================

# Generate TTS audio for a single script file
# Usage: just tts 01-problem
tts SEGMENT:
	{{VID_TTS}} --script "{{WORKDIR}}/scripts/{{SEGMENT}}.txt" \
		--output "{{WORKDIR}}/audio/{{SEGMENT}}.wav" \
		--print-duration

# Generate TTS for all script files
tts-all:
	#!/usr/bin/env bash
	for script in {{WORKDIR}}/scripts/*.txt; do
		name=$(basename "$script" .txt)
		echo "Generating TTS for $name..."
		{{VID_TTS}} --script "$script" \
			--output "{{WORKDIR}}/audio/${name}.wav" \
			--print-duration
	done

# ============================================================================
# Avatar Processing
# ============================================================================

# Stretch avatar for a segment (specify duration in seconds)
# Usage: just avatar-stretch 01-problem 8.5
avatar-stretch SEGMENT DURATION:
	{{VID_AVATAR}} --facing center \
		--duration {{DURATION}} \
		--reference-dir "{{REFDIR}}" \
		--output "{{WORKDIR}}/avatar/stretched/{{SEGMENT}}.mp4"

# Lip-sync avatar for a segment (run SEQUENTIALLY - GPU memory)
# Usage: just lipsync 01-problem
lipsync SEGMENT:
	{{VID_LIPSYNC}} --avatar "{{WORKDIR}}/avatar/stretched/{{SEGMENT}}.mp4" \
		--audio "{{WORKDIR}}/audio/{{SEGMENT}}.wav" \
		--output "{{WORKDIR}}/avatar/lipsynced/{{SEGMENT}}.mp4"

# ============================================================================
# Compositing
# ============================================================================

# Composite avatar onto content for a segment
# Usage: just composite 01-problem
composite SEGMENT:
	{{VID_COMPOSITE}} --content "{{WORKDIR}}/clips/{{SEGMENT}}.mp4" \
		--avatar "{{WORKDIR}}/avatar/lipsynced/{{SEGMENT}}.mp4" \
		--audio "{{WORKDIR}}/audio/{{SEGMENT}}.wav" \
		--output "{{WORKDIR}}/composited/{{SEGMENT}}.mp4"

# Add background music to a clip (for title/transition slides)
# Usage: just add-music 00-title 6.0
add-music SEGMENT DURATION:
	#!/usr/bin/env bash
	FADE_OUT=$(echo "{{DURATION}} - 2" | bc)
	ffmpeg -y -i "{{WORKDIR}}/clips/{{SEGMENT}}.mp4" -ss 15 -t {{DURATION}} -i "{{MUSIC}}" \
		-filter_complex "[1:a]volume=0.3,afade=t=in:st=0:d=1,afade=t=out:st=$FADE_OUT:d=2[aout]" \
		-map 0:v -map "[aout]" -c:v copy -c:a aac -shortest \
		"{{WORKDIR}}/composited/{{SEGMENT}}.mp4"

# ============================================================================
# Final Assembly
# ============================================================================

# Create silent MP4 from rendered frames (Phase 1 smoke test)
mux-silent:
	bash scripts/mux_ffmpeg.sh --fps {{FPS}} --in out/frames --out out/final.mp4

# Concatenate all composited segments into final video
concat:
	#!/usr/bin/env bash
	ls -1 "{{WORKDIR}}/composited/"*.mp4 | sort > "{{WORKDIR}}/composited/concat.txt"
	echo "{{REFDIR}}/epilog/99b-epilog.mp4" >> "{{WORKDIR}}/composited/concat.txt"
	{{VID_CONCAT}} --list "{{WORKDIR}}/composited/concat.txt" \
		--output out/final.mp4 \
		--reencode

# ============================================================================
# Review & Quality
# ============================================================================

# Preview composited segments in browser
review:
	{{VID_REVIEW}} "{{WORKDIR}}/composited" --scripts "{{WORKDIR}}/scripts" --port 3032

# ============================================================================
# Cleanup
# ============================================================================

clean:
	rm -rf out explainer_web/dist scripts/node_modules scripts/package-lock.json

clean-work:
	rm -rf {{WORKDIR}}/audio/*.wav {{WORKDIR}}/avatar/stretched/*.mp4 \
		{{WORKDIR}}/avatar/lipsynced/*.mp4 {{WORKDIR}}/clips/*.mp4 \
		{{WORKDIR}}/composited/*.mp4

clean-all: clean clean-work

# ============================================================================
# Full Pipeline (Example)
# ============================================================================

# Process a single segment end-to-end
# Usage: just process-segment 01-problem 8.5
process-segment SEGMENT DURATION:
	just tts {{SEGMENT}}
	just avatar-stretch {{SEGMENT}} {{DURATION}}
	just lipsync {{SEGMENT}}
	just composite {{SEGMENT}}

# Build everything from scratch
full-build:
	just web-build
	just render-plan
	just frames
	just tts-all
	# Note: Avatar stretch/lipsync/composite need individual durations
	# Run these manually or create a script with known durations
