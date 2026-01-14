# Turnkey Video Production Pipeline

## Vision
One command to produce an explainer video:
```bash
./produce-video.sh ~/github/project "Explain how the search algorithm works"
```

Outputs:
- `final.mp4` - Complete video with narration
- `segments/` - Individual clips for review
- `script.json` - Full production script

## Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        VIDEO PRODUCER AGENT                         │
│  (Claude analyzing repo and orchestrating production)               │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         1. SCRIPT GENERATION                        │
│  Input: repo path + topic                                           │
│  Output: script.json with segments                                  │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         2. ASSET GENERATION                         │
│  For each segment, generate appropriate asset:                      │
│  ├── CLI Demo → VHS tape → record with AI CLI → .mp4               │
│  ├── Diagram → SVG generation → render to .mp4                     │
│  ├── Screenshot → capture or generate → .mp4                       │
│  └── Avatar → TTS + lipsync → .mp4                                 │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         3. NARRATION GENERATION                     │
│  For each segment:                                                  │
│  ├── Generate narration script (VibeVoice format)                  │
│  ├── TTS → .wav                                                    │
│  └── Mix audio with video segment                                  │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         4. FINAL ASSEMBLY                           │
│  ├── Normalize all clips (1920x1080, 44100Hz stereo)               │
│  ├── Concatenate with vid-concat --reencode                        │
│  ├── Add title + epilog                                            │
│  └── Output final.mp4                                              │
└─────────────────────────────────────────────────────────────────────┘
```

## Script JSON Format

```json
{
  "title": "How RLM Solves Context Window Limits",
  "repo": "/Users/mike/github/softwarewrighter/rlm-project",
  "segments": [
    {
      "id": "01-hook",
      "type": "avatar",
      "narration": "What if your L L M could search ten million tokens using only three thousand.",
      "background": "svg",
      "svg_description": "Dark background with glowing '10M → 3K' text"
    },
    {
      "id": "02-problem",
      "type": "diagram",
      "narration": "Most L L Ms have a context window limit. When your document exceeds it, the model truncates and loses information.",
      "svg_description": "Diagram showing document being cut off, red X on truncated portion"
    },
    {
      "id": "03-demo-fail",
      "type": "cli",
      "cli": "claude",
      "narration": "Watch what happens when we ask a direct question about a large document.",
      "vhs_commands": [
        {"type": "claude --print 'Find the password in this 3MB file' < large.txt", "wait": 10},
        {"comment": "Shows truncation error or wrong answer"}
      ]
    },
    {
      "id": "04-solution",
      "type": "diagram",
      "narration": "R L M takes a different approach. Instead of cramming data into the context, it gives the L L M tools to explore.",
      "svg_description": "Flowchart: Query → LLM thinks → Commands → Execute → Loop or Final"
    },
    {
      "id": "05-demo-success",
      "type": "cli",
      "cli": "rlm",
      "narration": "Now watch R L M find the same answer using iterative search.",
      "vhs_commands": [
        {"cmd": "cd ~/github/softwarewrighter/rlm-project", "wait": 1},
        {"cmd": "./target/release/rlm demo/war-and-peace-needle.txt 'Find the password' -v", "wait": 30}
      ]
    },
    {
      "id": "06-results",
      "type": "diagram",
      "narration": "The results speak for themselves. Eighty six percent token savings on large documents.",
      "svg_description": "Bar chart comparing baseline tokens vs RLM tokens"
    },
    {
      "id": "07-cta",
      "type": "avatar",
      "narration": "R L M is open source. Try it on your own massive documents.",
      "background": "svg",
      "svg_description": "GitHub badge, feature list, link prompt"
    }
  ]
}
```

## Segment Type Handlers

### 1. CLI Demo (`type: "cli"`)
```bash
# Generate VHS tape from commands
generate_vhs_tape() {
  cat > segment.tape << EOF
Output segment.mp4
Set FontSize 18
Set Width 1920
Set Height 1080
Set Theme "Dracula"
# ... commands from script
EOF
  vhs segment.tape
}
```

### 2. Diagram (`type: "diagram"`)
```bash
# Generate SVG from description using Claude
generate_diagram() {
  claude --print "Generate SVG (1920x1080) for: $description" > diagram.svg
  # Convert to video with duration matching narration
  vid-image --input diagram.svg --duration $narration_duration --output segment.mp4
}
```

### 3. Avatar (`type: "avatar"`)
```bash
# Generate lip-synced avatar on SVG background
generate_avatar() {
  # Generate background SVG
  claude --print "Generate SVG background: $svg_description" > background.svg
  vid-image --input background.svg --duration 10 --output background.mp4

  # Generate TTS
  vid-tts --text "$narration" --output narration.wav

  # Lipsync avatar
  vid-lipsync --avatar curmudgeon.mp4 --audio narration.wav --output avatar.mp4

  # Composite
  vid-composite --content background.mp4 --avatar avatar.mp4 --output segment.mp4
}
```

### 4. Screenshot/Image (`type: "image"`)
```bash
# Use existing image or capture
generate_image_segment() {
  vid-image --input "$image_path" --duration $duration --ken-burns --output segment.mp4
}
```

## CLI Recording with AI Interaction

For recording actual AI CLI interactions:

```bash
# Method 1: VHS with scripted prompts (deterministic)
cat > demo.tape << 'EOF'
Output demo.mp4
Type "claude --dangerously-skip-permissions"
Enter
Sleep 5s
Type "Explain how RLM works"
Enter
Sleep 20s
Type "/exit"
Enter
EOF
vhs demo.tape

# Method 2: Real interaction with expect (variable responses)
expect << 'EOF'
spawn claude --dangerously-skip-permissions
sleep 5
send "Explain how RLM works\r"
sleep 20
send "/exit\r"
expect eof
EOF
```

## Key Tools Required

| Tool | Purpose | Source |
|------|---------|--------|
| `vhs` | Record CLI TUI interactions | charmbracelet/vhs |
| `vid-tts` | Text-to-speech | custom Rust tool |
| `vid-lipsync` | Avatar lip-sync | MuseTalk on hive |
| `vid-composite` | Overlay avatar on background | custom Rust tool |
| `vid-image` | Image/SVG to video | custom Rust tool |
| `vid-concat` | Concatenate clips | custom Rust tool |
| `agg` | asciinema to gif | asciinema/agg |
| `ffmpeg` | Video processing | ffmpeg |

## Workflow for Diagrams in CLI-Heavy Videos

Since CLI recordings can't show diagrams, interleave segment types:

```
[Avatar Hook] → [Diagram: Problem] → [CLI: Fail Demo] → [Diagram: Solution] → [CLI: Success Demo] → [Diagram: Results] → [Avatar CTA]
```

This alternates between:
- **Visual explanation** (SVG diagrams)
- **Proof** (CLI demos)
- **Human connection** (Avatar)

## Implementation Plan

1. **Phase 1: Script Generator**
   - Claude analyzes repo
   - Outputs script.json with segments

2. **Phase 2: Asset Generator**
   - Process each segment type
   - Generate VHS tapes, SVGs, avatars

3. **Phase 3: Narration Generator**
   - TTS for each segment
   - Mix with video

4. **Phase 4: Assembler**
   - Normalize all clips
   - Concatenate
   - Add title/epilog

## Example Usage

```bash
# Full pipeline
./produce-video.sh \
  --repo ~/github/softwarewrighter/rlm-project \
  --topic "How RLM solves context window limits" \
  --output ~/Videos/rlm-explainer.mp4

# Or step by step
./generate-script.sh --repo ~/github/rlm-project --topic "..." > script.json
./generate-assets.sh script.json
./generate-narration.sh script.json
./assemble-video.sh script.json --output final.mp4
```
