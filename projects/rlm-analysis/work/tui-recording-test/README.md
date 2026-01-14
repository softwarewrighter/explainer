# TUI Recording Toolkit

Tools for recording AI CLI demos (Claude Code, opencode, Gemini CLI, etc.)

## Quick Reference

| Tool | TUI Support | Headless | Real AI | Best For |
|------|-------------|----------|---------|----------|
| `vhs claude-tui.tape` | ✅ Full | ✅ Yes | ✅ Yes | Production demos |
| `record-tui-live.sh` | ✅ Full | ❌ No | ✅ Yes | Quick recordings |
| `real-claude-demo.sh` | ❌ --print | ✅ Yes | ✅ Yes | CI/automated |
| `simple-replay.sh` | ✅ Mocked | ✅ Yes | ❌ No | Prototyping |

## Why TUI Recording is Tricky

AI coding CLIs like Claude Code use **TUI frameworks** (ink, blessed, etc.) that:
- Require a real PTY (pseudo-terminal) to render
- Use escape sequences for colors, cursor positioning, screen clearing
- Redraw the entire screen on updates

**The solution**: Use tools that provide a virtual terminal:
- **VHS**: Creates its own virtual terminal ✅
- **expect**: Spawns a PTY for the child process ✅
- **tmux**: Provides PTY via terminal multiplexer ✅
- **asciinema alone**: Only works with existing TTY ⚠️

## Recording Methods

### 1. VHS (Recommended for Production)

VHS creates a virtual terminal and records scripted interactions.

```bash
# Install
brew install vhs

# Record
vhs claude-tui.tape

# Output: claude-tui-demo.gif, claude-tui-demo.mp4
```

Edit `claude-tui.tape` to customize:
```tape
Set FontSize 18
Set Theme "Dracula"

Type "claude --dangerously-skip-permissions"
Enter
Sleep 5s

Type "Your prompt here"
Enter
Sleep 10s  # Wait for response

Type "/exit"
Enter
```

### 2. Live Recording from Terminal

Run from a **real terminal** (not headless/CI):

```bash
# Basic recording
./record-tui-live.sh my-demo

# With custom prompts
echo '{"prompts": ["What is RLM?", "Show an example"]}' > prompts.json
./record-tui-live.sh my-demo prompts.json
```

### 3. Print Mode (Headless Compatible)

Uses `claude --print` (non-TUI output):

```bash
./real-claude-demo.sh output-name
```

### 4. Mocked Demo (No API Calls)

For prototyping or when you need exact control:

```bash
./simple-replay.sh output-name
```

## Creating Custom Demos

### JSON-Driven Conversations

Create a conversation file:
```json
{
  "prompts": [
    "What files are in this project?",
    "Explain the main function",
    "Add error handling to the code"
  ]
}
```

### VHS Tape Customization

```tape
# Timing
Set TypingSpeed 50ms      # How fast to "type"
Sleep 10s                  # Wait for AI response

# Appearance
Set FontSize 18
Set Width 1920
Set Height 1080
Set Theme "Dracula"        # or "GitHub", "Monokai", etc.

# Interaction
Type "your prompt"         # Types text
Enter                      # Press enter
Ctrl+C                     # Send interrupt
```

### Expect Script Customization

The expect script in `record-tui-live.sh` can be modified:
```expect
# Adjust timeout for slow responses
set timeout 180

# Send special keys
send "\x03"    # Ctrl+C
send "\x1b"    # Escape

# Wait for specific pattern
expect {
    "Claude:" { }
    timeout { puts "Timeout!" }
}
```

## Troubleshooting

### "TTY not available" Error
You're running headless. Use VHS or --print mode instead.

### TUI Not Rendering
- Ensure `TERM` is set: `export TERM=xterm-256color`
- Try VHS which provides its own terminal

### Recording Too Fast / Slow
- Adjust `Sleep` times in VHS tape
- Adjust `sleep` values in expect scripts
- AI responses vary - add buffer time

### Colors Not Showing
- Use `--cols 120 --rows 35` with agg
- Ensure terminal supports 256 colors

## File Reference

```
tui-recording-test/
├── README.md                 # This file
├── claude-tui.tape           # VHS tape for TUI recording
├── record-tui-live.sh        # Live recording from terminal
├── real-claude-demo.sh       # Real --print mode recording
├── simple-replay.sh          # Mocked demo (no API)
├── ai-cli-recorder.sh        # Multi-mode recorder
├── replay-conversation.sh    # JSON-driven replay
├── sample-conversation.json  # Example conversation
└── *.cast, *.gif, *.mp4      # Generated recordings
```

## Integration with Explainer Videos

These recordings can be used in explainer videos:
1. Record demo with VHS or asciinema
2. Convert to MP4: `ffmpeg -i demo.gif -pix_fmt yuv420p demo.mp4`
3. Import into video project as a clip
4. Add narration using TTS tools
