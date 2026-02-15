# Claude Code Instructions for Explainer Project

## Project Overview

This is a deterministic video rendering pipeline for creating explainer videos. It uses Rust/WASM for rendering, TTS for narration, and lip-sync for avatar overlays.

## Critical Guidelines

### MANDATORY: Follow the Style Guide

**NEVER guess or pick arbitrary values for font sizes, stroke widths, or other visual parameters.**

Before creating ANY visual asset (SVG, VHS tape, etc.):
1. Read `/docs/style-guide.md` for exact values
2. Use the `/style-check` command to validate assets
3. Reference prior successful projects if unsure

The style guide exists because guessing leads to inconsistent, unreadable videos.

### SVG Font Sizes - IMPORTANT

When creating or editing SVG slides for video, **never use fonts smaller than 28px**.

| Element | Minimum | Recommended |
|---------|---------|-------------|
| Headlines | 84px | **96px** |
| Subtitles | 42px | **48px** |
| Body text | 32px | **36px** |
| Labels/captions | 28px | **32px** |
| Monospace/URLs | 28px | **32px** |
| Stroke widths | 4px | **5px** |

**Examples:**
```svg
<!-- CORRECT -->
<text font-size="96">Main Headline</text>
<text font-size="48">Subtitle</text>
<text font-size="36">Body text</text>
<text font-size="32">Label or URL</text>
<rect stroke-width="5" ... />

<!-- WRONG - TOO SMALL -->
<text font-size="64">Headline</text>  <!-- Should be 84-96px -->
<text font-size="24">Label</text>      <!-- Should be 28px+ -->
<rect stroke-width="2" ... />          <!-- Should be 4-5px -->
```

See `/docs/style-guide.md` for complete guidelines.

### TTS Narration Rules

- Maximum 320 characters per script
- Use only periods and commas for punctuation
- No dashes, colons, semicolons, or question marks
- No exclamation marks
- **No special symbols** - spell out: "percent" not "%", "dollar" not "$", "at" not "@"
- **No digits** - spell out all numbers as words (e.g., "sixty thousand" not "60,000")
- Spell out acronyms (e.g., "Language Model" not "LLM", "Recursive Language Model" not "RLM")
- Short, simple sentences work best

See `/docs/tts-narration-guidelines.md` and `/docs/style-guide.md` for complete rules.

### Video Tools

Tools are in `../video-publishing/tools/target/release/`:
- `vid-tts` - Text to speech (VibeVoice only)
- `vid-image` - Create video from image
- `vid-avatar` - Stretch avatar duration
- `vid-lipsync` - Lip sync avatar to audio
- `vid-composite` - Overlay avatar on content
- `vid-concat` - Concatenate clips

### VoxCPM TTS (Voice Cloning)

For voice-cloned narration, use VoxCPM via Gradio API instead of vid-tts.

**Server:** `http://curiosity:7860`

**CRITICAL: Sequential Calls Only**
All TTS API calls to VoxCPM MUST be made sequentially. Never queue multiple requests in parallel - this overloads the GPU and produces garbled output. Wait for each request to complete before starting the next.

**Working Settings:**
- `do_normalize=False` (True drops words)
- `cfg_value_input=2.0` (default)
- `inference_timesteps_input=10` (default)
- Use "M H C" instead of "mHC" for proper pronunciation of acronyms

**CRITICAL: Use the 63s reference file with its matching prompt text.**

**PREFERRED (63s) - USE THESE:**
```
REF="/Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.wav"
PROMPT="In this session, I'm going to write a small command line tool and explain the decision making process as I go. I'll begin with a basic skeleton, argument parsing, a configuration loader, and a minimal main function. Once everything compiles, I'll run it with a few sample inputs to confirm the behavior. After that, I'll be fine the internal design. I'll reorganize the functions, extract shared logic, and add error messages that actually help the user understand what went wrong. None of this is complicated, but it's the kind of work that separates a rough prototype from a tool someone can rely on. As we move forward, I'll highlight why I chose certain patterns, some decisions, optimize clarity, while others optimize performance or extensibility. The important thing is to understand the trade-offs well enough that the code feels intentional instead of accidental."
```

**DO NOT USE (17s) - THESE PRODUCE GARBLED OUTPUT:**
```
# WRONG - Do not use these:
# /Users/mike/github/softwarewrighter/explainer/projects/apl/work/reference/mike-ref-17s.wav
# /Users/mike/github/softwarewrighter/explainer/projects/engram-poc/work/reference/mike-ref-17s.wav
# /Users/mike/github/softwarewrighter/explainer/projects/mHC-poc/work/reference/mike-ref-17s.wav
# Any file named mike-ref-17s.wav or mike-ref-17s-clean.wav
```

**When TTS produces garbled/unintelligible output, the cause is ALWAYS one of:**
1. Using the wrong reference file (17s instead of 63s)
2. Using prompt text that doesn't match the reference audio
3. Mixing a reference file with the wrong prompt text

See `projects/pipeline-rs/work/generate-tts.sh` for the working example to copy from.

**Curl API Pattern:**
```bash
REF_PATH="/tmp/gradio/.../mike-ref-17s.wav"  # Upload first
PROMPT="In this session, I'm going to write a small command line tool..."

cat > /tmp/tts.json << JSONEOF
{"data": ["Your text here", {"path": "$REF_PATH", "url": "http://curiosity:7860/gradio_api/file=$REF_PATH", "orig_name": "mike-ref-17s.wav", "mime_type": "audio/wav", "is_stream": false, "meta": {"_type": "gradio.FileData"}}, "$PROMPT", 2.0, 10, false]}
JSONEOF

ID=$(curl -s -X POST "http://curiosity:7860/gradio_api/call/generate" -H "Content-Type: application/json" -d @/tmp/tts.json | jq -r '.event_id')
sleep 20  # Wait for generation
RESULT=$(curl -s "http://curiosity:7860/gradio_api/call/generate/$ID")
URL=$(echo "$RESULT" | grep -o '"url": "[^"]*"' | head -1 | cut -d'"' -f4)
curl -s "$URL" -o output.wav
```

**Always verify with whisper after generation:**
```bash
ffmpeg -y -i output.wav -ar 16000 -ac 1 -c:a pcm_s16le /tmp/verify.wav
whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/verify.wav -nt
```

**Setup:**
```bash
cd projects/YOUR_PROJECT/tts
uv venv && source .venv/bin/activate
uv pip install gradio_client
```

**Usage:**
```bash
source tts/.venv/bin/activate
python tts/client.py "Your narration text here" work/audio/01-hook.wav
```

### MuseTalk Lip-Sync Workflow

**Servers:** `http://hive:3015` and `http://hive:3016` (can run in parallel)

**CRITICAL: The workflow requires silent avatar video + separate audio:**

1. **Stretch curmudgeon avatar to match audio duration:**
```bash
$VID_AVATAR --avatar ../video-publishing/reference/curmudgeon.mp4 \
  --duration $(ffprobe -v error -show_entries format=duration -of csv=p=0 work/audio/01-hook.wav) \
  --output work/avatar/01-hook-stretched.mp4
```

2. **Remove audio from stretched avatar (make silent):**
```bash
ffmpeg -y -i work/avatar/01-hook-stretched.mp4 -an -c:v copy work/avatar/01-hook-silent.mp4
```

3. **Run lip-sync with silent video + audio:**
```bash
$VID_LIPSYNC --avatar work/avatar/01-hook-silent.mp4 \
  --audio work/audio/01-hook.wav \
  --output work/avatar/01-hook-lipsync.mp4 \
  --server http://hive:3015
```

4. **Composite lip-synced avatar onto base video:**
```bash
ffmpeg -y -i work/clips/01-hook-base.mp4 -i work/avatar/01-hook-lipsync.mp4 \
  -filter_complex "[1:v]scale=200:200[avatar];[0:v][avatar]overlay=W-w-20:H-h-20:shortest=1[outv]" \
  -map "[outv]" -map 0:a -c:v libx264 -crf 18 -c:a copy \
  work/clips/01-hook-composited.mp4
```

**Notes:**
- Use port 3016 for parallel processing (e.g., CTA while hook processes)
- If server returns 0 frames, restart the MuseTalk service on hive
- Long audio (>15s) works fine; no need to segment
- The vid-composite tool may fail if avatar has no audio; use ffmpeg directly

### Project Structure

Each video project lives in `projects/<name>/` with:
- `assets/svg/` - SVG graphics (minimum 28px fonts!)
- `assets/images/` - Title cards, backgrounds
- `work/scripts/` - Narration text files
- `work/audio/` - Generated TTS audio
- `work/clips/` - Video clips
- `work/stills/` - PNG renders from SVG
- `work/avatar/` - Avatar processing files
- `docs/` - Project documentation

### Avatar Workflow

Use `scripts/build-avatar-clip.sh` for lip-synced avatar clips:
1. SVG → PNG (rsvg-convert)
2. PNG → base clip (vid-image with ken-burns)
3. Stretch avatar (vid-avatar --avatar /path/to/avatar.mp4 --duration X --output Y)
4. Lip-sync (vid-lipsync --avatar /path/to/stretched.mp4 --audio /path/to/audio.wav --output Y)
5. Composite (vid-composite --content base.mp4 --avatar lipsync.mp4 --output composited.mp4 --size 200)
6. Normalize volume (normalize-volume.sh)

**Avatar Selection:**
- **curmudgeon** - Current series (rlm-llm, rlm-llm-big, etc.)
- **polo** - Older videos only
- Source: `../video-publishing/reference/curmudgeon.mp4`

**Fixing Avatar Without Re-lipsync:**
If you only need to fix the background slide (not the audio), just re-composite:
```bash
# Render new slide, create new base video, composite existing lipsync avatar
$VID_IMAGE --image work/stills/99-cta.png --duration 15.73 --output work/clips/99-cta-base-new.mp4
$VID_COMPOSITE --content work/clips/99-cta-base-new.mp4 --avatar work/avatar/99-cta-lipsync.mp4 --output work/clips/99-cta-composited.mp4 --size 200
```

### Outro Requirements

- **Duration**: 12 seconds (not 5)
- **Music**: Same as title card (e.g., "Two Gong Fire")
- **Fade out**: Music fades out over last 3 seconds

```bash
ffmpeg -y -loop 1 -i epilog-frame.png \
  -i "/path/to/music.mp3" \
  -filter_complex "[1:a]atrim=0:12,afade=t=out:st=9:d=3,volume=0.5[a]" \
  -map 0:v -map "[a]" \
  -c:v libx264 -crf 18 -t 12 -r 30 \
  -c:a aac -b:a 192k -pix_fmt yuv420p \
  work/clips/99c-epilog-ext.mp4
```

### Realigning Video to Audio (Without Re-recording)

When audio duration changes, realign existing video instead of re-recording VHS:

```bash
# Target duration = audio_duration + 1 second
# PTS factor = target_duration / source_duration

# Example: 15s video → 18.2s target (audio 17.2s + 1s)
# PTS = 18.2 / 15 = 1.213 (slow down)

ffmpeg -y -i source.mp4 -i audio.wav \
  -filter_complex "[0:v]setpts=1.213*PTS[v]" \
  -map "[v]" -map 1:a \
  -c:v libx264 -crf 18 -c:a aac -b:a 192k \
  -shortest output.mp4
```

**Guidelines:**
- Add 1 second padding to audio duration for video target
- PTS > 1.0 = slow down video, PTS < 1.0 = speed up video
- Always normalize after realignment

### Audio Verification with Whisper

Use whisper-cli to verify TTS audio matches the original script.

**Models (already downloaded):**
- `~/.whisper-models/ggml-base.en.bin` - Fast, good quality (148MB)
- `~/.local/share/whisper-cpp/models/ggml-medium.en.bin` - Slower, better accuracy (1.5GB)

**Usage:**
```bash
# Extract audio to 16kHz mono WAV (required format)
ffmpeg -y -i clip.mp4 -ar 16000 -ac 1 -c:a pcm_s16le /tmp/audio.wav

# Transcribe with base model (fast)
whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/audio.wav -nt

# Transcribe with medium model (more accurate)
whisper-cli -m ~/.local/share/whisper-cpp/models/ggml-medium.en.bin -f /tmp/audio.wav -nt
```

**When to verify:**
- After generating TTS for new narration
- Before final video assembly
- When debugging audio issues

**Expected discrepancies (acceptable):**
- Proper nouns may be misheard ("Ralphy" → "Ralphie")
- "Claude Code" often transcribed as "Cloud Code"
- Technical terms may vary slightly

### VHS Terminal Recordings

**Required VHS Settings (MANDATORY):**
```tape
Set Shell "bash"          # CRITICAL: Must set shell to bash
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20
```

**NEVER use FontSize below 28.** FontSize 32 is recommended for all VHS recordings.

When recording terminal demos with VHS that require environment variables (e.g., LiteLLM API keys):

**Environment Variable Pattern (CRITICAL):**
```tape
# Always combine export with command using && on ONE line
Type "export $(cat ~/.env | grep -v '^#' | xargs) && ./your-script.sh"
Enter
```

This reliably exports variables from `~/.env` (e.g., `LITELLM_MASTER_KEY`, `LITELLM_HOST`).

**What does NOT work:**
- `source ~/.env` - not reliable in VHS
- Separate export and command lines (environment may not persist)
- Hide/Show blocks with exports (shell state may reset)

**CRITICAL - One Command = One Type + One Enter:**

Each bash command MUST be a single `Type` statement followed by ONE `Enter`. NEVER split a command across multiple Type/Enter pairs.

```tape
# CORRECT - entire command in one Type
Type "./rlm file.txt 'query here' --flag1 --flag2 -vv"
Enter

# WRONG - splits command into separate executions
Type "./rlm file.txt"
Enter
Type "'query here'"
Enter
Type "--flag1 --flag2"
Enter
```

The wrong approach executes three separate bash commands instead of one. VHS `Enter` sends a literal Enter keypress, which bash interprets as "execute now".

### Video Concatenation - CRITICAL

**NEVER use raw ffmpeg for concatenation.** Always use `vid-concat`:

```bash
# Create concat list (absolute paths, one per line, NO "file '...'" prefix)
/full/path/to/clips/00-title.mp4
/full/path/to/clips/01-hook-composited.mp4
...

# Concatenate with vid-concat
$VID_CONCAT --list clips/concat-list.txt --output preview.mp4 --reencode
```

**Audio Format Requirements:**
All clips MUST be 44100Hz stereo before concatenation. Run `normalize-volume.sh` on EVERY clip:

```bash
./scripts/normalize-volume.sh work/clips/02-intro.mp4
# Output: "02-intro.mp4  FORMAT FIXED: 24000 Hz 1 ch -> 44100 Hz stereo"
```

If clips have mixed audio formats (some 24000Hz mono, some 44100Hz stereo), the concatenated video will have audio issues - some clips will be silent or garbled.

### OBS Recording Workflow - CRITICAL

When processing OBS screen recordings (e.g., visualizer demos):

**1. Extract stills to identify segment boundaries:**
```bash
# Extract stills every 0.5 seconds
ffmpeg -i recording.mp4 -vf "fps=2" stills/frame_%04d.jpg

# Check dimensions - OBS often records at Retina resolution (3024x1862)
sips -g pixelHeight -g pixelWidth stills/frame_0001.jpg
```

**2. Create resized thumbnails for analysis (API limit is 2000px):**
```bash
sips -Z 1200 frame_0001.jpg --out thumbs/frame_0001.jpg
```

**3. Extract video segments - MUST SCALE TO 1920x1080:**
```bash
# Extract with scaling (OBS recordings are often 3024x1862)
ffmpeg -y -ss START -i recording.mp4 -t DURATION \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -crf 18 -an clip.mp4
```

**4. Adjust video duration to match audio + 0.5s padding:**
```bash
# Calculate speed factor: src_duration / target_duration
# pts_factor = 1 / speed
ffmpeg -y -i clip.mp4 -i audio.wav \
  -filter_complex "[0:v]scale=1920:1080:...,setpts=PTS_FACTOR*PTS[v]" \
  -map "[v]" -map 1:a \
  -c:v libx264 -crf 18 -c:a aac -b:a 192k \
  -shortest output.mp4
```

**5. ALWAYS normalize after creating clips:**
```bash
./scripts/normalize-volume.sh clip.mp4
```

**6. Verify dimensions before concatenation:**
```bash
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 clip.mp4
# Must output: 1920,1080
```

**Key errors to avoid:**
- Forgetting to scale OBS recordings to 1920x1080
- Using raw video dimensions from Retina displays (3024x1862, etc.)
- Not running normalize-volume.sh on EVERY clip

### Common Mistakes to Avoid

1. **Small fonts** - Never below 28px in SVGs
2. **Text overflow** - Text must fit within boxes with padding
3. **Thin strokes** - Use stroke-width 4-5px for visibility
4. **Wrong TTS punctuation** - Periods and commas only
5. **Long narration** - Keep under 320 chars
6. **Missing audio normalization** - Always run normalize-volume.sh on EVERY clip
7. **Forgetting avatar overlay area** - Keep bottom-right clear
8. **Skipping whisper verification** - Always verify TTS before final assembly
9. **VHS env vars** - Use `export $(cat ~/.env | ...)` pattern, not `source ~/.env`
10. **Raw ffmpeg concat** - NEVER use `ffmpeg -f concat`, always use `vid-concat`
11. **Mixed audio formats** - ALL clips must be 44100Hz stereo before concat
12. **Wrong concat list format** - Use absolute paths, NO `file '...'` prefix
13. **OBS dimension mismatch** - Always scale OBS recordings to 1920x1080, Retina is 3024x1862
14. **TTS wording issues** - Avoid "Demo one/two" (sounds like "GIMA"), use "First up", "Next", "Third", "Finally"
15. **VHS command splitting** - NEVER split a bash command across multiple Type/Enter pairs. One command = one Type + one Enter
16. **VHS font size too small** - NEVER use FontSize below 28. Always use FontSize 32 for readable recordings
17. **Guessing visual parameters** - NEVER guess font sizes or stroke widths. Always check `/docs/style-guide.md`
18. **TTS special symbols** - Never use %, $, @, etc. Spell out "percent", "dollar", "at"
19. **Wrong avatar** - Use curmudgeon for current series, not polo
20. **Outro too short** - Outro must be 12 seconds with same music as title, fading out
21. **Re-running VHS unnecessarily** - Realign existing video to new audio using PTS, don't re-record
22. **Wrong tool options** - vid-avatar uses `--avatar`, vid-lipsync uses `--avatar` not `--video`
23. **Parallel remote service calls** - NEVER make parallel API calls to the same service (e.g., VoxCPM). Always wait for each request to complete before starting the next. Parallel calls overload the GPU and produce garbled output.
24. **Wrong TTS prompt text** - The prompt text MUST match the reference audio exactly. Use whisper to verify. Mismatched prompts produce unintelligible output.
25. **TTS acronyms** - Spell out acronyms with spaces for proper pronunciation: "M H C" not "mHC", "R L M" not "RLM"
26. **Wrong TTS reference file** - When TTS produces garbled output, verify the reference WAV and prompt text match. Prefer the 63s reference (`mike-medium-ref-1.wav`) over shorter references. Never mix reference files with mismatched prompt text. Check `projects/pipeline-rs/work/generate-tts.sh` for the correct prompt text
