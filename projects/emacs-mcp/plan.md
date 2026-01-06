# Emacs MCP Server Explainer Video - Production Plan

A short explainer video about a Rust-based MCP server that enables LLMs to control Emacs.

> **Reference**: See [Video Pipeline Guide](../../docs/tools.md) for tool documentation.

---

## Project Info

| Field | Value |
|-------|-------|
| **Project** | emacs-mcp |
| **Video Title** | Emacs MCP: Let AI Control Your Editor |
| **Subject Repo** | ../emacs-ai-api |
| **Target Duration** | ~4 minutes |
| **Format** | Animated explainer (static SVG + voiceover, no avatar) |
| **Music** | missed-chance.mp3 (title + epilog extension) |

---

## Research Summary

### What is Emacs?

- **Origin**: GNU Emacs created by Richard Stallman in 1984, over 40 years old
- **Core Concept**: Self-documenting, extensible text editor with Lisp interpreter
- **Modern Use**: Coding, writing, email, org-mode, terminal, file management
- **Key Feature**: Emacs Lisp allows complete customization of every behavior
- **Server Mode**: `emacs --daemon` enables external control via `emacsclient`

### What is MCP (Model Context Protocol)?

- **Created by**: Anthropic (November 2024)
- **Purpose**: Standardize how LLMs connect to external tools and data sources
- **Architecture**: JSON-RPC 2.0 over stdin/stdout
- **Analogy**: "USB-C for AI integrations" - one protocol for all tools

### MCP Adoption (2025)

| Company | Adoption |
|---------|----------|
| **Anthropic** | Created MCP, uses in Claude Desktop |
| **OpenAI** | Adopted March 2025 for ChatGPT, Agents SDK |
| **Microsoft** | Joined steering committee May 2025 |
| **Google** | DeepMind integration announced |

### Common MCP Servers

| Server | Purpose |
|--------|---------|
| **Playwright** | Browser automation for testing |
| **Filesystem** | Secure file operations |
| **GitHub** | Repository management |
| **Memory** | Persistent knowledge graphs |
| **Postgres/SQLite** | Database queries |

### MCP Challenges (Why Caution is Warranted)

- **Security**: 43% of tested implementations had command injection vulnerabilities
- **Complexity**: OAuth 2.1 implementation is non-trivial
- **Single-Tenant**: Most servers designed for single-user, not multi-agent
- **Context Limits**: Performance degrades as more tools are added

### This Implementation: emacs-ai-api

**Key Innovation**: Rust-based MCP server exposing Emacs operations to LLMs

**Four Core Tools**:
1. `dired` - Open directory listings
2. `open-file` - Load files into buffers
3. `insert` - Add text at cursor position
4. `split-window` - Manage window layouts

**Architecture**:
```
LLM → JSON-RPC → Emacs MCP Server (Rust) → emacsclient → Emacs
```

**Demo Applications**:
- Automated code review with inline comments
- Remote pair programming via web UI
- AI-powered documentation generation
- Log file analysis with markers

---

## Narrative Structure

### Part 1: INTRO - "Tell them what you are going to tell them" (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 01-title | Title card + music | (music only, 4s) |
| 02-hook | AI robot at keyboard | "What if AI could control your text editor. Not just suggest changes, but actually make them." |
| 03-problem | Copy paste cycle | "Today, AI suggests code. You copy. You paste. You repeat. There is a better way." |
| 04-solution | MCP bridge diagram | "The Model Context Protocol connects AI directly to your tools. Including Emacs." |
| 05-preview | Three icons | "Today we cover Emacs, MCP servers, and a Rust implementation that ties them together." |

### Part 2: BODY - "Tell them" (~120s)

#### Section A: What is Emacs? (~25s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 06-emacs-intro | Emacs logo | "Emacs is a text editor. But calling it that undersells it completely." |
| 07-emacs-power | Lisp code flowing | "It runs Lisp. You can customize everything. Keybindings, colors, even how it saves files." |
| 08-emacs-uses | Multiple windows | "Developers use it for coding, writing, email, and managing files. Some never leave it." |
| 09-emacs-server | Daemon icon | "Emacs can run as a server. External programs send commands. The editor executes them." |

#### Section B: MCP Protocol (~40s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 10-mcp-what | Protocol diagram | "MCP is the Model Context Protocol. Anthropic created it in late 2024." |
| 11-mcp-problem | N times M grid | "Before MCP, connecting AI to tools was messy. Every model needed custom integrations." |
| 12-mcp-solution | Single connector | "MCP provides one protocol. AI models speak it. Tools implement it. Everyone connects." |
| 13-mcp-how | JSON-RPC flow | "It uses JSON messages over standard input and output. Simple, portable, language agnostic." |
| 14-mcp-examples | Playwright logo | "Playwright uses MCP for browser automation. So do file systems, databases, and GitHub." |
| 15-mcp-adoption | Company logos | "OpenAI adopted it. Microsoft joined the steering committee. It became the standard fast." |
| 16-mcp-caution | Warning sign | "But MCP has rough edges. Security issues exist. Complexity grows with scale." |

#### Section C: This Implementation (~55s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 17-impl-overview | Rust + Emacs | "This MCP server is written in Rust. It exposes four Emacs operations to AI agents." |
| 18-tool-dired | Directory tree | "Tool one is dired. It opens directory listings. AI can browse your file system." |
| 19-tool-open | File opening | "Tool two is open file. It loads any file into an Emacs buffer for viewing or editing." |
| 20-tool-insert | Text insertion | "Tool three is insert. It adds text at the cursor. AI can write code directly into your file." |
| 21-tool-split | Window split | "Tool four is split window. Horizontal or vertical. AI arranges your workspace." |
| 22-flow-diagram | Full architecture | "The flow is simple. AI sends JSON. The server translates. Emacs executes. You see results." |
| 23-demo-review | Code review | "Example one. Automated code review. AI opens your file and inserts comments at the top." |
| 24-demo-pair | Pair programming | "Example two. Remote pair programming. A web interface lets multiple users share one Emacs." |
| 25-demo-docs | Documentation | "Example three. Documentation generation. AI writes headers for every file in a directory." |
| 26-why-rust | Rust crab | "Why Rust. Fast, safe, no runtime. The server handles requests without overhead." |

### Part 3: SUMMARY - "Tell them what you told them" (~25s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 27-recap-emacs | Emacs icon | "Emacs is extensible. It runs as a server. External programs can control it." |
| 28-recap-mcp | MCP icon | "MCP standardizes AI to tool connections. JSON messages, universal protocol." |
| 29-recap-impl | Rust + Emacs | "This Rust server bridges the two. Four tools give AI direct access to your editor." |
| 30-key-insight | Lightbulb | "The key insight. AI becomes an extension of your editor, not a separate window." |
| 31-cta | GitHub links | "Code and documentation links are below. Thanks for watching." |

---

## Audio Settings

```bash
# Reduced padding for tight pacing
--pad-start 0.3 --pad-end 0.3

# Example:
$VID_TTS --script work/scripts/02-hook.txt \
  --output work/audio/02-hook.wav \
  --pad-start 0.3 --pad-end 0.3 \
  --print-duration
```

---

## Visual Requirements

### SVGs Needed (30 unique visuals)

```
assets/svg/
  01-title.svg          # Title card (or use image)
  02-hook.svg           # AI robot at keyboard
  03-problem.svg        # Copy paste cycle
  04-solution.svg       # MCP bridge diagram
  05-preview.svg        # Three topic icons
  06-emacs-intro.svg    # Emacs logo
  07-emacs-power.svg    # Lisp code flowing
  08-emacs-uses.svg     # Multiple windows
  09-emacs-server.svg   # Daemon/server icon
  10-mcp-what.svg       # Protocol diagram
  11-mcp-problem.svg    # N x M grid problem
  12-mcp-solution.svg   # Single connector solution
  13-mcp-how.svg        # JSON-RPC flow
  14-mcp-examples.svg   # Playwright and tools
  15-mcp-adoption.svg   # Company logos
  16-mcp-caution.svg    # Warning/caution sign
  17-impl-overview.svg  # Rust + Emacs combo
  18-tool-dired.svg     # Directory tree
  19-tool-open.svg      # File opening animation
  20-tool-insert.svg    # Text insertion
  21-tool-split.svg     # Window splitting
  22-flow-diagram.svg   # Full architecture
  23-demo-review.svg    # Code review example
  24-demo-pair.svg      # Pair programming
  25-demo-docs.svg      # Documentation generation
  26-why-rust.svg       # Rust crab/benefits
  27-recap-emacs.svg    # Emacs recap
  28-recap-mcp.svg      # MCP recap
  29-recap-impl.svg     # Implementation recap
  30-key-insight.svg    # Lightbulb insight
  31-cta.svg            # GitHub/links CTA
```

---

## Tool Locations

```bash
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR="/Users/mike/github/softwarewrighter/explainer/projects/emacs-mcp/work"
MUSIC="$REFDIR/music/missed-chance.mp3"

VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_CONCAT="$TOOLS/vid-concat"
VID_MUSIC="$TOOLS/vid-music"
```

---

## Production Steps

### Step 1: Write Scripts
```bash
# One script per segment (max 200 chars, 2 sentences)
work/scripts/02-hook.txt
work/scripts/03-problem.txt
# ... etc
```

### Step 2: Generate Audio
```bash
for script in work/scripts/*.txt; do
  name=$(basename "$script" .txt)
  $VID_TTS --script "$script" \
    --output "work/audio/${name}.wav" \
    --pad-start 0.3 --pad-end 0.3 \
    --print-duration
done
```

### Step 3: Create SVGs
```bash
# Create 30 unique SVGs in assets/svg/
# Each should be 1920x1080, dark theme, clear visuals
```

### Step 4: Convert SVGs to PNG
```bash
for svg in assets/svg/*.svg; do
  name=$(basename "$svg" .svg)
  rsvg-convert -w 1920 -h 1080 "$svg" -o "work/png/${name}.png"
done
```

### Step 5: Build Video Clips
```bash
# Title clip with missed-chance.mp3
$VID_IMAGE --image assets/images/emacs-mcp.jpg \
  --output work/clips/01-title.mp4 \
  --duration 4.0 \
  --music "$MUSIC" \
  --music-offset 15 --volume 0.3

# Content clips with voiceover and Ken Burns effect
for audio in work/audio/*.wav; do
  name=$(basename "$audio" .wav)
  $VID_IMAGE --image "work/png/${name}.png" \
    --output "work/clips/${name}.mp4" \
    --audio "$audio" \
    --effect ken-burns
done
```

### Step 6: Concatenate
```bash
ls work/clips/*.mp4 | sort > work/clips/concat-list.txt
echo "$REFDIR/epilog/99b-epilog.mp4" >> work/clips/concat-list.txt
$VID_CONCAT --list work/clips/concat-list.txt \
  --output work/emacs-mcp-draft.mp4 \
  --reencode
```

### Step 7: Add Epilog Extension
```bash
# Extract frame from epilog and create 5s extension with missed-chance.mp3
ffmpeg -y -ss 5.0 -i "$REFDIR/epilog/99b-epilog.mp4" -frames:v 1 work/stills/epilog-frame.png
$VID_IMAGE --image work/stills/epilog-frame.png \
  --output work/clips/99c-epilog-ext.mp4 \
  --duration 5.0 \
  --music "$MUSIC" \
  --music-offset 60 --volume 0.3
# Append to concat list and re-concatenate
```

---

## YouTube Metadata

### Title
"Emacs MCP Server: Let AI Control Your Editor (Rust Implementation)"

### Description
```
What if AI could control your text editor directly?

This Rust-based MCP server bridges LLMs and Emacs, enabling AI to open files, insert code, and manage windows.

In this video:
- 0:00 Introduction
- 0:30 What is Emacs?
- 1:00 MCP Protocol Explained
- 1:40 This Implementation (4 Core Tools)
- 2:35 Demo Examples
- 3:00 Summary

Code: https://github.com/softwarewrighter/emacs-ai-api
Documentation: https://github.com/softwarewrighter/emacs-ai-api/wiki

MCP Resources:
- Official Spec: https://modelcontextprotocol.io
- Playwright MCP: https://github.com/microsoft/playwright-mcp

Emacs Resources:
- GNU Emacs: https://www.gnu.org/software/emacs/

#Emacs #MCP #AI #Rust #LLM #ModelContextProtocol #Anthropic #OpenSource
```

---

## Script Guidelines

### Rules for VibeVoice TTS
1. Max 200 characters per script file
2. Max 2 sentences per script file
3. Only periods and commas (use periods not question marks)
4. No ALL-CAPS words (use "m c p" not "MCP", "a i" not "AI")
5. Short sentences work best
6. Spell out acronyms phonetically

### Pacing
- Use `--pad-start 0.3 --pad-end 0.3` for tight pacing

---

## File Organization

```
projects/emacs-mcp/
+-- plan.md              # This file
+-- docs/
|   +-- research.md      # Research notes
+-- assets/
|   +-- images/          # Title card (emacs-mcp.jpg)
|   +-- svg/             # 30 unique SVG visuals
+-- work/
    +-- scripts/         # Narration text (02-*.txt through 31-*.txt)
    +-- audio/           # TTS audio (.wav)
    +-- png/             # Converted SVGs
    +-- clips/           # Individual video clips
    +-- stills/          # Extracted frames
    +-- emacs-mcp-draft.mp4  # Final draft
```

---

## Segment Summary

| Section | Segments | Est. Duration |
|---------|----------|---------------|
| Intro | 4 narrated | ~25s |
| Emacs | 4 | ~25s |
| MCP Protocol | 7 | ~40s |
| Implementation | 10 | ~55s |
| Summary | 5 | ~25s |
| **Total** | **30 narrated** | **~170s (~2:50)** |

Plus title (4s) + epilog (12.8s) + extension (5s) = **~195s (~3:15)**
