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

### SVG Visual Design - CRITICAL

**NEVER create boring, repetitive box-and-border layouts.**

All SVG slides MUST use modern, visually engaging design (PaperBanana style):

**Required elements (include at least 3 per slide):**
- Rich gradient backgrounds (not flat colors)
- Decorative shapes (circles, polygons at low opacity)
- Emoji/icon embellishments (🚀 ⚡ 🔍 💡 🎯 ✨ 📊 🔐)
- Terminal mockups with colored window dots
- Glow filters for emphasis
- Colored top bars on cards (not just borders)
- Checkmarks/X marks for lists (✓ ✗)
- Arrow transitions for flow diagrams

**Background template:**
```svg
<linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
  <stop offset="0%" style="stop-color:#0f0c29"/>
  <stop offset="50%" style="stop-color:#302b63"/>
  <stop offset="100%" style="stop-color:#24243e"/>
</linearGradient>
```

**Card template (with colored top bar):**
```svg
<rect x="100" y="200" width="800" height="400" rx="24" fill="url(#cardGrad)"/>
<rect x="100" y="200" width="800" height="8" rx="4" fill="#4ade80"/>
```

**Terminal mockup:**
```svg
<rect x="150" y="300" width="720" height="80" rx="12" fill="#0a0a14"/>
<circle cx="180" cy="340" r="8" fill="#ff6b6b"/>
<circle cx="210" cy="340" r="8" fill="#ffd93d"/>
<circle cx="240" cy="340" r="8" fill="#4ade80"/>
```

**What NOT to do:**
- ❌ Flat single-color backgrounds
- ❌ Plain rectangular boxes with just colored borders
- ❌ No visual embellishments or icons
- ❌ Same repetitive layout for every slide
- ❌ Missing terminal mockups for CLI content

See `/docs/style-guide.md` Section 2.5 for complete visual design requirements.

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

**Server:** `http://queenbee.local:7860` (curiosity is down for repairs)

**CRITICAL: Sequential Calls Only**
All TTS API calls to VoxCPM MUST be made sequentially. Never queue multiple requests in parallel - this overloads the GPU and produces garbled output. Wait for each request to complete before starting the next.

**Working Settings:**
- `do_normalize=False` (True drops words)
- `cfg_value_input=2.0` (default)
- `inference_timesteps_input=15` (not 10)
- Use "M H C" instead of "mHC" for proper pronunciation of acronyms

### Voice Reference - USE THESE TWO FILES TOGETHER

```
WAV: /Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.wav
TXT: /Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.txt
```

**Usage:**
```bash
REF="/Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.wav"
REF_TXT="/Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.txt"
PROMPT_TEXT="$(cat "$REF_TXT")"
```

### DO NOT USE (deprecated)

17s reference files have been moved to `deprecated-17s/` directory. Never use them.

### Garbled Output = Wrong WAV/TXT Combination

**If TTS produces garbled/unintelligible output, you are using the wrong combination.**

There is exactly ONE correct combination:
- `mike-medium-ref-1.wav` + `mike-medium-ref-1.txt`

Any other combination will produce garbled output.

See `/docs/tts.md` for complete documentation.

**Always verify with whisper after generation:**
```bash
ffmpeg -y -i output.wav -ar 16000 -ac 1 -c:a pcm_s16le /tmp/verify.wav
whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/verify.wav -nt
```

**Setup (once per project):**
```bash
cd projects/YOUR_PROJECT/tts
uv venv && source .venv/bin/activate
uv pip install gradio_client
```

**Usage - PREFERRED METHOD:**

Each project should have a `work/generate-tts.sh` script that encapsulates the correct reference file and prompt text. To generate TTS:

1. Add your narration text files to `work/scripts/` (e.g., `01-hook.txt`, `02-overview.txt`)
2. Run the script:
```bash
cd work && ./generate-tts.sh
```

The script will:
- Find all `*.txt` files in `work/scripts/`
- Skip files that already have audio in `work/audio/`
- Generate TTS with correct reference and prompt text
- Verify each output with whisper

**Copy `generate-tts.sh` from an existing project** (e.g., `projects/pipeline-rs/work/generate-tts.sh` or `projects/neural-net-rs/work/generate-tts.sh`) to ensure correct settings.

**Direct client.py usage (NOT recommended - error prone):**
```bash
# Only use if you understand the reference/prompt requirements
source tts/.venv/bin/activate
python tts/client.py --reference REF --prompt-text "PROMPT" --text "TEXT" --output out.wav
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

**STATUS: Lip-synced avatars are currently SKIPPED.** The MuseTalk server (hive:3015/3016) is offline and lip-sync is not planned for the foreseeable future. Create clips directly from stills with audio instead.

**Current workflow (no avatar):**
1. SVG → PNG (rsvg-convert)
2. PNG + audio → clip (ffmpeg)
3. Normalize volume (normalize-volume.sh)

```bash
# Create clip from still + audio
ffmpeg -y -loop 1 -i work/stills/01-hook.png \
  -i work/audio/01-hook.wav \
  -c:v libx264 -tune stillimage -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k \
  -shortest \
  work/clips/01-hook.mp4

# Normalize
./scripts/normalize-volume.sh work/clips/01-hook.mp4
```

**Legacy Avatar Workflow (NOT IN USE):**
For reference only - lip-synced avatar clips used:
1. Stretch avatar (vid-avatar)
2. Lip-sync (vid-lipsync --server hive:3015)
3. Composite (vid-composite)

### Video Segment Naming - SEE FULL GUIDE

**Read `/docs/video-segment-naming.md` for complete naming conventions.**

### Final 3 Segments - CRITICAL STRUCTURE

**Every explainer video MUST end with exactly these 3 segments:**

| # | Segment | File | Audio | Reuse |
|---|---------|------|-------|-------|
| 98 | CTA | `98-cta.mp4` | NARRATION (project-specific) | UNIQUE |
| 99 | Subscribe Reminder | `99-subscribe-reminder.mp4` | PRE-RECORDED NARRATION | **SHARED** |
| 99x | Outro | `99x-outro.mp4` | MUSIC with fade-out | UNIQUE |

### Subscribe Reminder (99-subscribe-reminder.mp4) - ALWAYS COPY

**Canonical file location:**
```
/Users/mike/github/softwarewrighter/explainer/shared/99-subscribe-reminder-narrated.mp4
```

**Copy to every project:**
```bash
cp /Users/mike/github/softwarewrighter/explainer/shared/99-subscribe-reminder-narrated.mp4 \
   projects/YOUR_PROJECT/work/clips/99-subscribe-reminder.mp4
```

**Properties:**
- Duration: 12.817 seconds
- Audio: NARRATION saying "If you found this helpful, please like and subscribe..."
- Audio is NOT music

**NEVER:**
- Create a new subscribe reminder (always copy the shared one)
- Use one that has music instead of narration
- Copy from random projects (some have bad versions from past mistakes)

**Verify with whisper:**
```bash
ffmpeg -y -i work/clips/99-subscribe-reminder.mp4 -ar 16000 -ac 1 -c:a pcm_s16le /tmp/verify.wav
whisper-cli -m ~/.whisper-models/ggml-base.en.bin -f /tmp/verify.wav -nt
# MUST show: "like and subscribe" (NOT "[MUSIC]")
```

### Outro (99x-outro.mp4) - UNIQUE PER VIDEO

- **Visual**: Same slide as subscribe reminder (extract last frame)
- **Audio**: Same MUSIC as title card, with 3s fade-out
- **Duration**: 7-12 seconds
- **NEVER reuse** - each video gets unique outro with its own music

```bash
# Extract last frame from subscribe reminder
ffmpeg -y -sseof -0.1 -i work/clips/99-subscribe-reminder.mp4 -vframes 1 work/stills/99-outro-frame.png

# Create outro with this video's music
ffmpeg -y -loop 1 -i work/stills/99-outro-frame.png \
  -i assets/music.wav \
  -filter_complex "[1:a]atrim=START:END,asetpts=PTS-STARTPTS,afade=t=out:st=FADE_START:d=3,volume=0.5[a]" \
  -map 0:v -map "[a]" \
  -c:v libx264 -tune stillimage -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k -t DURATION -r 30 \
  work/clips/99x-outro.mp4
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
26. **Wrong TTS reference file** - When TTS produces garbled output, verify the reference WAV and prompt text match. Prefer the 63s reference (`mike-medium-ref-1.wav`) over shorter references. Never mix reference files with mismatched prompt text
27. **Bypassing generate-tts.sh** - ALWAYS use the project's `work/generate-tts.sh` script for TTS generation. It encapsulates the correct reference file and prompt text. Never manually construct TTS commands with client.py - this is error-prone and leads to garbled output
28. **Two-step audio combination** - Use `vid-image --audio` to include audio directly. The two-step process (vid-image then ffmpeg add audio) often produces silent tracks. The vid-image tool properly handles audio when using the `--audio` flag
29. **Wrong image dimensions** - Title backgrounds and all images must be 1920x1080 before creating video. Scale with ffmpeg: `ffmpeg -i input.png -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" output.png`
30. **Forgetting to rebuild silent slides** - If slides have -91 dB audio (essentially silent), the audio was not combined properly. Rebuild using `vid-image --audio` or use explicit `-map 0:v -map 1:a` in ffmpeg
31. **Truncating OBS/VHS recordings** - NEVER truncate screen recordings to match audio duration. If video is longer than audio, pad the audio with silence: `apad=whole_dur=VIDEO_DURATION`. If video is shorter than audio, slow down video with setpts. Always use full source video duration
32. **Run-on narration (no pause between clips)** - Add 200ms silence padding at the end of every narrated clip to prevent run-on dialog: `ffmpeg -i clip.mp4 -filter_complex "[0:a]apad=pad_dur=0.2[a]" -map 0:v -map "[a]" -c:v copy -c:a aac output.mp4`
33. **Using -shortest flag with demos** - The `-shortest` flag cuts video to match audio, truncating important content. Never use `-shortest` with OBS/VHS demos. Instead, extend audio to match video
34. **TTS run-on sentences** - TTS may run sentences together without natural pauses. Use punctuation (periods, commas) to control pacing. If pauses are still insufficient, the simple fix is adding extra punctuation in the script. Avoid the complex approach of splitting into separate TTS calls and concatenating with silence
35. **Wrong subscribe reminder source** - ALWAYS copy from `/explainer/shared/99-subscribe-reminder-narrated.mp4`. NEVER copy from random project directories. Verify with whisper - must say "like and subscribe", not "[MUSIC]"
36. **Creating new subscribe reminder** - NEVER create a new 99-subscribe-reminder. The shared one is pre-rendered with correct narration. Just copy it
37. **Reusing outro across videos** - NEVER reuse 99x-outro.mp4 across videos. Each video must have its own unique outro with that video's music
38. **Subscribe reminder with music** - If 99-subscribe-reminder has music instead of narration, it's WRONG. Must have narration: "If you found this helpful, please like and subscribe..."
39. **Confusing segment names** - Use new naming: `99-subscribe-reminder.mp4` (shared, narration) and `99x-outro.mp4` (unique, music). See `/docs/video-segment-naming.md`
