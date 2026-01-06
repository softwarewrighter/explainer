# Development Tools

This document describes the recommended tools for working with this project, particularly for AI coding agents and developers.

## Tool Location

Recommended tools are installed in `~/.local/softwarewrighter/bin/`:

```bash
# List available tools
ls -la ~/.local/softwarewrighter/bin/

# Add to PATH (if not already in ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.local/softwarewrighter/bin:$PATH"
```

## Tool Help Convention

**IMPORTANT**: All tools in `~/.local/softwarewrighter/bin/` support `--help` with AI coding agent-specific sections. These extended help sections provide additional context, examples, and best practices tailored for AI agents.

```bash
# Standard help (short)
tool-name -h

# Extended help with AI sections (recommended)
tool-name --help
```

## Core Tools

### 1. proact - AI Agent Documentation Generator

**Repository**: https://github.com/softwarewrighter/proact
**Version**: 0.1.0

**Purpose**: Generates comprehensive AI coding agent documentation for projects

**When to Use**:
- When starting work on a new project
- When you want standardized AI agent instructions
- When docs/learnings.md needs to be initialized or updated
- When project processes/standards have changed

**Installation**:
```bash
# Already installed in ~/.local/softwarewrighter/bin/
```

**Usage**:
```bash
# Generate docs for current project
proact .

# Generate docs for specific project
proact /path/to/project

# Custom output directory
proact /path/to/project -o documentation

# Preview what would be generated (dry-run)
proact . --dry-run

# Verbose output
proact . --verbose
```

**What It Generates**:
- `docs/ai_agent_instructions.md` - Comprehensive AI coding agent guidelines
  - Process-oriented workflow
  - Quality standards
  - Testing strategies
  - Tech debt avoidance
  - Playwright MCP setup
  - Project-specific guidelines (Rust, WASM, etc.)
- `docs/learnings.md` - Template for capturing issues and solutions
  - Common patterns that cause problems
  - Proactive prevention strategies
  - Root cause analysis examples

**Key Features**:
- Enforces checkpoint process (tests, linting, formatting, docs, git)
- Includes Playwright MCP setup instructions
- Project-specific guidelines based on technology detected
- Continuous improvement focus
- Tech debt limits (file size, TODO count, etc.)

**AI Agent Notes**:
When proact generates documentation for a project, it creates a baseline. You should:
1. Read the generated docs/ai_agent_instructions.md
2. Follow the checkpoint process it describes
3. Update docs/learnings.md when you encounter issues
4. Run proact again if project structure changes significantly

### 2. markdown-checker - Markdown Validation Tool

**Repository**: https://github.com/softwarewrighter/markdown-checker
**Version**: 0.1.0

**Purpose**: Ensures markdown files use ASCII-only characters for maximum portability

**When to Use**:
- BEFORE committing any markdown changes (part of pre-commit process)
- After editing README.md or any docs/*.md files
- When preparing documentation for GitHub (web preview compatibility)
- To fix Unicode characters (arrows, emojis, box-drawing)

**Installation**:
```bash
# Already installed in ~/.local/softwarewrighter/bin/
```

**Usage**:
```bash
# Validate README.md in current directory
markdown-checker

# Validate specific file
markdown-checker -f CONTRIBUTING.md

# Validate all markdown in directory
markdown-checker -f "*.md"

# Validate recursively (all markdown in docs/)
markdown-checker -p docs -f "**/*.md"

# Auto-fix tree symbols
markdown-checker --fix

# Preview fixes without applying
markdown-checker --dry-run

# Verbose output
markdown-checker -v
```

**Validation Rules**:
- [x] ASCII characters (32-126)
- [x] Whitespace (space, tab, LF, CR)
- [x] Unicode arrows (-> becomes ->)
- [x] Emojis ([x] becomes [x] or remove)
- [x] Box-drawing characters (+|+- becomes +|-)

**Auto-Fixable**:
- Tree symbols: `+ -> +`, `| -> |`, `+ -> +`, `- -> -`

**Not Auto-Fixable** (manual intervention required):
- Unicode arrows (->)
- Emojis ([x] [x] [WIP])
- Accented characters (e a n)
- Other non-ASCII Unicode

**Why ASCII-Only?**:
- GitHub README web preview works correctly
- Compatible with all terminals and editors
- Works in CI/CD pipelines
- Accessible to screen readers
- No encoding issues

**Pre-Commit Integration**:
```bash
# Part of mandatory pre-commit process
markdown-checker -f "**/*.md"
# Fix any issues before committing
```

**AI Agent Notes**:
- ALWAYS run markdown-checker before committing documentation
- Use --fix for tree symbols, manually fix other Unicode
- If validation fails, FIX the issues (never skip this step)
- Common fixes:
  - `->` becomes `->`
  - `[x]` becomes `[x]` in checklists
  - `[WIP]` becomes `[WIP]` or remove
  - Box-drawing trees become ASCII trees

### 3. sw-install - Binary Installation Tool

**Repository**: https://github.com/softwarewrighter/sw-install
**Version**: 0.1.0

**Purpose**: Installs compiled Rust binaries to `~/.local/softwarewrighter/bin/`

**When to Use**:
- First-time setup of development environment
- After building a new Rust CLI tool locally
- When updating an existing tool
- When you need a specific version of a tool

**Installation**:
```bash
# Already installed in ~/.local/softwarewrighter/bin/
```

**First-Time Setup**:
```bash
# 1. Setup installation directory and PATH
sw-install --setup-install-dir

# 2. Reload shell configuration
source ~/.bashrc  # or ~/.zshrc
```

**Usage**:
```bash
# Install a binary from project (release build)
sw-install -p ~/projects/markdown-checker

# Install with custom name
sw-install -p ~/projects/ask -r ask-dev

# Install debug build (for development)
sw-install -p ~/projects/proact -d

# Uninstall a binary
sw-install -u markdown-checker

# Dry-run (preview what would happen)
sw-install -p ~/projects/ask --dry-run

# Verbose output
sw-install -p ~/projects/ask --verbose
```

**How It Works**:
1. Detects Rust project (looks for Cargo.toml)
2. Finds binary name from Cargo.toml [[bin]] section
3. Copies from `target/release/` or `target/debug/`
4. Installs to `~/.local/softwarewrighter/bin/`
5. Makes executable (chmod +x)

**PATH Configuration**:
After `--setup-install-dir`, adds to your shell RC file:
```bash
export PATH="$HOME/.local/softwarewrighter/bin:$PATH"
```

**AI Agent Notes**:
- Use sw-install when you build a new tool and want it available globally
- Prefer release builds for performance: `sw-install -p <path>`
- Use debug builds for development: `sw-install -p <path> -d`
- Check which tools are available: `ls ~/.local/softwarewrighter/bin/`

### 4. ask - Command-Line LLM Query Tool

**Repository**: https://github.com/softwarewrighter/ask
**Version**: 0.1.0

**Purpose**: Query language models from the command line for quick assistance

**When to Use**:
- Need quick answers without opening a full AI interface
- Testing API integrations
- Generating code snippets
- Answering technical questions
- Prototyping prompts

**Installation**:
```bash
# Already installed in ~/.local/softwarewrighter/bin/
```

**Usage**:
```bash
# Query with default settings (Ollama, phi3:3.8b)
ask "How do I parse JSON in Rust?"

# Use a specific platform and model
ask -p openai -m gpt-4 "Explain async/await in Rust"

# Use shortcut for platform/model combo
ask -s  # List available shortcuts
ask -s sonnet "Write a bash script to..."

# Dry run (show request without calling API)
ask -n "Test query"

# Verbose output
ask -v "Debug query"

# Show usage statistics
ask --usage-report
```

**Supported Platforms**:
- Ollama (default, local)
- OpenAI (requires API key)
- Anthropic (requires API key)

**Configuration**:
```bash
# API keys via environment variables
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."

# Or via config file
~/.config/ask/config.toml
```

**AI Agent Notes**:
- Useful for quick references without context switching
- Ollama is default (runs locally, no API costs)
- Set API keys in environment for OpenAI/Anthropic
- Use --usage-report to track API costs

### 5. sw-checklist - Software Wrighter Project Requirements Checker

**Repository**: https://github.com/softwarewrighter/sw-checklist
**Version**: 0.1.0

**Purpose**: Ensures that a project meets Software Wrighter standards and requirements

**When to Use**:
- Before committing changes to verify project compliance
- When setting up a new project to ensure all requirements are met
- During pre-commit process to validate project structure
- To identify missing or non-compliant project elements

**Installation**:
```bash
# Already installed in ~/.local/softwarewrighter/bin/
```

**Usage**:
```bash
# Run checklist on current project
sw-checklist

# Show extended help with AI agent guidance
sw-checklist --help

# Run with verbose output
sw-checklist -v

# Dry run (preview checks without modifications)
sw-checklist --dry-run
```

**What It Checks**:
- Project structure and required files
- Documentation completeness
- Code quality standards
- Testing requirements
- License and copyright information
- Build and deployment configuration

**AI Agent Notes**:
- Run sw-checklist before creating commits to ensure compliance
- Use --help to understand specific requirements for your project type
- Address all checklist failures before pushing to remote
- Integrate into pre-commit workflow for automated validation

### 6. favicon - Favicon Generator

**Repository**: https://github.com/softwarewrighter/favicon
**Version**: 0.1.0

**Purpose**: Generates favicon.ico files for web projects

**When to Use**:
- Setting up a new web project that needs a favicon
- Creating placeholder favicons during development
- Generating production-ready favicon files

**Installation**:
```bash
# Already installed in ~/.local/softwarewrighter/bin/
```

**Usage**:
```bash
# Show extended help with AI agent guidance
favicon --help

# Generate red question mark on transparent background (placeholder)
# Run this in the directory where index.html is served (e.g., public/ or static/)
favicon -T -t "?" -b ff0000

# Common options:
# -T          : Transparent background
# -t "TEXT"   : Text to render in favicon
# -b RRGGBB   : Background color (hex)
# -f RRGGBB   : Foreground/text color (hex)
```

**Common Patterns**:

```bash
# Placeholder during development (red question mark)
cd public  # or wherever index.html is served
favicon -T -t "?" -b ff0000

# Development marker (yellow "D")
favicon -T -t "D" -b ffff00 -f 000000

# Staging marker (orange "S")
favicon -T -t "S" -b ff8800 -f ffffff

# Production placeholder (blue "P")
favicon -T -t "P" -b 0066ff -f ffffff
```

**AI Agent Notes**:
- ALWAYS run favicon in the directory where index.html is served
- Common locations: public/, static/, dist/, www/
- Replace placeholder favicons before production deployment
- Use distinctive colors/text for different environments (dev/staging/prod)
- The -T flag creates transparent backgrounds for better visual appearance

## Tool Discovery

When new tools are added to `~/.local/softwarewrighter/bin/`:

1. **List available tools**:
   ```bash
   ls -la ~/.local/softwarewrighter/bin/
   ```

2. **Check tool help**:
   ```bash
   <tool-name> --help  # Extended help with AI sections
   <tool-name> -h      # Short help
   ```

3. **Test with dry-run** (if supported):
   ```bash
   <tool-name> --dry-run <args>
   ```

4. **Update this doc** when new useful tools are discovered

## Integration with This Project

### Pre-Commit Process

From docs/process.md, the following tools are used:

```bash
# Step 1: Tests
cargo test

# Step 2: Linting
cargo clippy --all-targets --all-features -- -D warnings

# Step 3: Formatting
cargo fmt --all

# Step 4: Markdown validation (THIS IS WHERE markdown-checker IS USED)
markdown-checker -f "**/*.md"

# Step 6: Update documentation
# If issues found, update docs/learnings.md
# Can use proact to regenerate if major changes
```

### Documentation Workflow

```bash
# 1. Make code/doc changes
vim README.md

# 2. Validate markdown before commit
markdown-checker -f "README.md"

# 3. Fix any issues
# (manually replace Unicode, or use --fix for tree symbols)

# 4. If new patterns found, update docs/learnings.md

# 5. Optionally regenerate full docs
proact .

# 6. Commit changes
git commit -m "docs: Update README with new features"
```

## Best Practices

### For AI Coding Agents

1. **Always check tool help first**:
   ```bash
   <tool> --help  # Not -h, use --help for AI-specific sections
   ```

2. **Use dry-run mode when learning**:
   ```bash
   proact . --dry-run
   markdown-checker --dry-run
   ```

3. **Integrate into workflow**:
   - Use markdown-checker in pre-commit process (mandatory)
   - Use proact when starting new projects
   - Update docs/learnings.md when encountering issues

4. **Validate before committing**:
   ```bash
   # Always run before commit if markdown changed
   markdown-checker -f "**/*.md"
   ```

5. **Keep tools updated**:
   ```bash
   # Rebuild and reinstall tool
   cd ~/projects/markdown-checker
   cargo build --release
   sw-install -p .
   ```

### For Human Developers

1. **Setup PATH once**:
   ```bash
   sw-install --setup-install-dir
   source ~/.bashrc
   ```

2. **Install tools as needed**:
   ```bash
   # Clone and build
   git clone https://github.com/softwarewrighter/<tool>.git
   cd <tool>
   cargo build --release

   # Install globally
   sw-install -p .
   ```

3. **Use in pre-commit hooks** (future):
   ```bash
   # .git/hooks/pre-commit
   #!/bin/bash
   markdown-checker -f "**/*.md" || exit 1
   ```

## Troubleshooting

### Tool Not Found

```bash
# Check if tool exists
ls ~/.local/softwarewrighter/bin/

# Check if PATH is set
echo $PATH | grep softwarewrighter

# Re-run setup if needed
sw-install --setup-install-dir
source ~/.bashrc  # or ~/.zshrc
```

### markdown-checker Validation Failures

```bash
# See detailed errors
markdown-checker -v

# Try auto-fix for tree symbols
markdown-checker --fix

# For other Unicode, manually replace:
# -> with ->
# [x] with [x]
# [WIP] with [WIP] or remove
```

### Permission Denied

```bash
# Tools should be executable, but if not:
chmod +x ~/.local/softwarewrighter/bin/<tool-name>
```

## Video Pipeline Tools

These tools are located in `../video-publishing/tools/target/release/` and are used for generating TTS audio, lip-synced avatars, and composited video clips.

### Tool Locations

```bash
# Video pipeline tools
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"

# Individual tools
VID_FRAMES="$TOOLS/vid-frames"
VID_TTS="$TOOLS/vid-tts"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
VID_SPEEDUP="$TOOLS/vid-speedup"
VID_SLIDE="$TOOLS/vid-slide"
VID_REVIEW="$TOOLS/vid-review"
```

### Reference Files

```
../video-publishing/reference/
+-- center-polo.mp4      # Avatar facing camera (for slides)
+-- left-polo.mp4        # Avatar facing left (for OBS overlays)
+-- right-polo.mp4       # Avatar facing right (optional)
+-- epilog/
|   +-- 99b-epilog.mp4   # Standard closing segment (12.8s)
+-- music/
|   +-- swing9.mp3       # Background music (150s)
+-- voice/
|   +-- mike-medium-ref-1.wav  # Voice clone reference (63s)
+-- docs/
    +-- video-pipeline-guide.md
```

### 7. vid-tts - Text-to-Speech Generator

**Purpose**: Generate TTS audio with voice cloning using VibeVoice server

**External Service**: curiosity:7861 (VibeVoice TTS server)

**When to Use**:
- Generating narration audio from script text
- Creating voiceover for explainer videos
- Producing audio segments for lip-sync

**Usage**:
```bash
# Generate TTS audio from script file (includes 1s padding automatically)
$VID_TTS --script scripts/00-intro.txt \
  --output audio/00-intro.wav \
  --print-duration

# Voice reference is configured internally (mike-medium-ref-1.wav)
```

**AI Agent Notes**:
- ALWAYS use vid-tts instead of calling podcast CLI directly
- Audio is automatically padded with 1s silence at start/end (configurable with --pad-start, --pad-end)
- Use --print-duration to get audio length for avatar stretching
- Voice clone reference: mike-medium-ref-1.wav (63s sample)

**VibeVoice Limitations** (IMPORTANT):
- **Max 200 characters** per script, **max 2 sentences**
- **Only periods and commas** - no colons, semicolons, exclamation marks, question marks, or special punctuation
- **No ALL-CAPS words** - VibeVoice garbles words like "ERROR" or "RLM"
  - Use lowercase: "error" not "ERROR"
  - For acronyms, use spaced letters: "R L M" not "RLM" (pronounces each letter)
- **Avoid**: "search for ERROR" -> use "search for error"
- **Avoid**: "the RLM project" -> use "the R L M project"
- Keep sentences short and natural for best voice quality

### 8. vid-avatar - Avatar Video Stretcher

**Purpose**: Stretch avatar video to match audio duration

**When to Use**:
- After generating TTS audio
- Before lip-sync processing
- When avatar duration needs to match narration length

**Usage**:
```bash
# Stretch avatar to match audio duration
$VID_AVATAR --facing left \
  --duration 10.27 \
  --reference-dir "$REFDIR" \
  --output avatar/stretched/00-intro.mp4

# Facing options: left (OBS), center (slides), right
```

**AI Agent Notes**:
- Use "left" facing for OBS screen recordings (avatar looks at content)
- Use "center" facing for slides (avatar looks at camera)
- Duration should match PADDED audio duration
- Reference dir contains the source avatar videos

### 9. vid-lipsync - Lip Sync Generator

**Purpose**: Generate lip-synced avatar video using MuseTalk

**External Service**: hive:3015 (MuseTalk server)

**When to Use**:
- After stretching avatar to match audio
- Creating lip-synced talking head videos
- Adding narration overlay to content

**Usage**:
```bash
$VID_LIPSYNC --avatar avatar/stretched/00-intro.mp4 \
  --audio audio/00-intro.wav \
  --output avatar/lipsynced/00-intro.mp4

# Server defaults to hive:3015
```

**AI Agent Notes**:
- Run lip-sync jobs SEQUENTIALLY (not parallel) - ~4GB GPU memory per job
- Uses approximately 1-2 minutes per segment
- Always use padded audio for proper timing
- Output FPS defaults to 30

### 10. vid-composite - Video Compositor

**Purpose**: Overlay avatar on content video with audio

**When to Use**:
- Combining lip-synced avatar with screen recording
- Creating final composited segments
- Adding narration overlay to slides

**Usage**:
```bash
$VID_COMPOSITE --content clips/00-obs-clip.mp4 \
  --avatar avatar/lipsynced/00-intro.mp4 \
  --audio audio/00-intro.wav \
  --output composited/00-intro.mp4

# Options: --size 240 (default), --position bottom-right (default)
```

**AI Agent Notes**:
- Avatar size is 240x240 by default
- Position is bottom-right for OBS, can be center for slides
- Content video is the background (screen recording or slide)
- Audio replaces original content audio

### 11. vid-concat - Video Concatenator

**Purpose**: Concatenate multiple video segments into final video

**When to Use**:
- Combining all composited segments into final video
- Creating full video from segment list

**Usage**:
```bash
# Create concat list file (one path per line)
# Then concatenate
$VID_CONCAT --list composited/concat.txt \
  --output composited/final.mp4 \
  --reencode
```

**AI Agent Notes**:
- Use --reencode for consistent codec across segments
- Concat list should list files in order
- Files should have same resolution and FPS

### 12. vid-slide - Slide Generator

**Purpose**: Generate title/content slides as video

**When to Use**:
- Creating title cards
- Making section transition slides
- Generating summary slides with bullet points

**Usage**:
```bash
# Title slide
$VID_SLIDE --title "Recursive Language Models" \
  --subtitle "Expanding the Workspace" \
  --duration 4.0 \
  --output clips/00-title.mp4

# Bullet point slide
$VID_SLIDE --title "Key Features" \
  --bullet "Context Box for large inputs" \
  --bullet "Structured JSON commands" \
  --bullet "Helper AI for chunk analysis" \
  --output clips/02-features.mp4
```

**AI Agent Notes**:
- Duration is in seconds
- Use for slides that need music (no narration)
- Can also use for avatar slides (with vid-composite after)

### 13. vid-speedup - Video Speed Controller

**Purpose**: Create fast-forward segments

**When to Use**:
- Showing boring build output quickly
- Creating time-lapse of long processes
- Compressing waiting periods

**Usage**:
```bash
$VID_SPEEDUP --input source.mp4 \
  --speed 16.0 \
  --mute \
  --start 120 \
  --duration 60 \
  --output clips/ff-build.mp4
```

**AI Agent Notes**:
- Speed is multiplier (4x, 8x, 16x common)
- Use --mute to remove original audio
- Start and duration are in seconds
- Add background music after with ffmpeg

### 14. vid-frames - Frame Extractor

**Purpose**: Extract still frames from video for AI analysis

**When to Use**:
- Extracting keyframes for script writing
- Creating stills for thumbnail generation
- Analyzing video content

**Usage**:
```bash
$VID_FRAMES --input source.mp4 \
  --output stills/segment-01 \
  --interval 30
```

**AI Agent Notes**:
- Interval is in seconds between frames
- Useful for writing narration scripts based on visual content
- Stills are named frame_0001.jpg, frame_0002.jpg, etc.

### 15. vid-review - Composited Preview Server

**Purpose**: Preview composited segments in web browser

**When to Use**:
- Reviewing generated segments before concat
- Checking audio/video sync
- Verifying compositing quality

**Usage**:
```bash
$VID_REVIEW composited/ \
  --scripts scripts/ \
  --port 3032
```

**AI Agent Notes**:
- Opens web server to preview all segments
- Shows script text alongside video
- Useful for quality review before final concat

## FORBIDDEN: Direct Tool Usage

**DO NOT** use these commands directly - use the vid-* tools instead:

| DO NOT USE | USE INSTEAD |
|------------|-------------|
| `ffmpeg -vf "fps=1/30"` | `$VID_FRAMES --interval 30` |
| `ffmpeg -af adelay` | `$VID_TTS` (handles padding) |
| `ffmpeg -vf setpts` | `$VID_AVATAR` or `$VID_SPEEDUP` |
| `podcast --host` | `$VID_TTS --script` |
| `musetalk-cli --server` | `$VID_LIPSYNC --avatar` |
| `ffmpeg -filter_complex overlay` | `$VID_COMPOSITE` |
| `ffmpeg -f concat` | `$VID_CONCAT` |

## Future Tools

As new tools are added to `~/.local/softwarewrighter/bin/`, document them here:

**Template**:
```markdown
### Tool Name

**Purpose**: Brief description

**When to Use**:
- Use case 1
- Use case 2

**Usage**:
```bash
tool-name --help
tool-name <common-usage>
```

**AI Agent Notes**:
- Specific guidance for AI agents
- Integration with project workflow
```
