# Claude Code Instructions for Explainer Project

## Project Overview

This is a deterministic video rendering pipeline for creating explainer videos. It uses Rust/WASM for rendering, TTS for narration, and lip-sync for avatar overlays.

## Critical Guidelines

### SVG Font Sizes - IMPORTANT

When creating or editing SVG slides for video, **never use fonts smaller than 28px**.

| Element | Minimum | Recommended |
|---------|---------|-------------|
| All text | **28px** | 28-32px |
| Body/labels | 28px | 32px |
| Monospace/URLs | 28px | 32px |
| Subtitles | 36px | 42-48px |
| Headlines | 84px | 96px |
| Stroke widths | 4px | 5px |

**Examples:**
```svg
<!-- CORRECT -->
<text font-size="28">github.com/user/repo</text>
<text font-size="32">Label Text</text>
<rect stroke-width="5" ... />

<!-- WRONG - TOO SMALL -->
<text font-size="22">Label Text</text>
<text font-size="24">github.com/repo</text>
```

See `/docs/svg-design-guidelines.md` for complete guidelines.

### TTS Narration Rules

- Maximum 240 characters per script
- Use only periods and commas for punctuation
- No dashes, colons, semicolons, or question marks
- No exclamation marks
- Spell out acronyms (e.g., "R L M" not "RLM")
- Short, simple sentences work best

### Video Tools

Tools are in `../video-publishing/tools/target/release/`:
- `vid-tts` - Text to speech
- `vid-image` - Create video from image
- `vid-avatar` - Stretch avatar duration
- `vid-lipsync` - Lip sync avatar to audio
- `vid-composite` - Overlay avatar on content
- `vid-concat` - Concatenate clips

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
3. Stretch avatar (vid-avatar)
4. Lip-sync (vid-lipsync on hive server)
5. Composite (vid-composite)
6. Normalize volume (normalize-volume.sh)

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

When recording terminal demos with VHS that require environment variables (e.g., LiteLLM API keys):

**Environment Variable Pattern:**
```
Type "export $(cat ~/.env | grep -v '^#' | xargs) && ./your-script.sh"
```

This reliably exports variables from `~/.env` (e.g., `LITELLM_MASTER_KEY`, `LITELLM_HOST`).

**Important:** `source ~/.env` does not work reliably in VHS recordings. Always use the export pattern above.

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

### Common Mistakes to Avoid

1. **Small fonts** - Never below 28px in SVGs
2. **Text overflow** - Text must fit within boxes with padding
3. **Thin strokes** - Use stroke-width 4-5px for visibility
4. **Wrong TTS punctuation** - Periods and commas only
5. **Long narration** - Keep under 240 chars
6. **Missing audio normalization** - Always run normalize-volume.sh on EVERY clip
7. **Forgetting avatar overlay area** - Keep bottom-right clear
8. **Skipping whisper verification** - Always verify TTS before final assembly
9. **VHS env vars** - Use `export $(cat ~/.env | ...)` pattern, not `source ~/.env`
10. **Raw ffmpeg concat** - NEVER use `ffmpeg -f concat`, always use `vid-concat`
11. **Mixed audio formats** - ALL clips must be 44100Hz stereo before concat
12. **Wrong concat list format** - Use absolute paths, NO `file '...'` prefix
