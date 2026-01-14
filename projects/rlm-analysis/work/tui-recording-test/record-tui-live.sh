#!/bin/bash
# Record Live TUI Demo - Must be run from a REAL terminal (not headless)
#
# This script records actual Claude Code TUI interactions using expect.
# It requires a real TTY to work properly.
#
# Usage: ./record-tui-live.sh [output-name] [script.json]
#
# Examples:
#   ./record-tui-live.sh my-demo                    # Use default prompts
#   ./record-tui-live.sh my-demo prompts.json       # Use custom prompts

set -e

OUTPUT="${1:-live-tui-demo}"
PROMPTS_FILE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check for TTY
if [ ! -t 0 ] || [ ! -t 1 ]; then
    echo "ERROR: This script requires a real terminal (TTY)"
    echo ""
    echo "You're running in headless mode. To record TUI demos:"
    echo ""
    echo "Option 1: Run from a real terminal"
    echo "  $ cd $SCRIPT_DIR"
    echo "  $ ./record-tui-live.sh"
    echo ""
    echo "Option 2: Use VHS (works headless)"
    echo "  $ vhs claude-tui.tape"
    echo ""
    echo "Option 3: Use --print mode (non-TUI)"
    echo "  $ ./real-claude-demo.sh"
    exit 1
fi

# Default prompts
DEFAULT_PROMPTS=(
    "What files are in this directory?"
    "Explain what this project does in one sentence"
    "Show me a simple example"
)

# Load prompts from JSON if provided
if [[ -n "$PROMPTS_FILE" && -f "$PROMPTS_FILE" ]]; then
    if command -v jq &> /dev/null; then
        mapfile -t PROMPTS < <(jq -r '.prompts[]' "$PROMPTS_FILE")
    else
        echo "Warning: jq not found, using default prompts"
        PROMPTS=("${DEFAULT_PROMPTS[@]}")
    fi
else
    PROMPTS=("${DEFAULT_PROMPTS[@]}")
fi

echo "╭─────────────────────────────────────────────────────────────╮"
echo "│  Live TUI Recording                                         │"
echo "╰─────────────────────────────────────────────────────────────╯"
echo ""
echo "Output: ${OUTPUT}.cast"
echo "Prompts: ${#PROMPTS[@]}"
for p in "${PROMPTS[@]}"; do
    echo "  • $p"
done
echo ""
echo "Starting in 3 seconds..."
sleep 3

# Create expect script
EXPECT_SCRIPT=$(mktemp)
cat > "$EXPECT_SCRIPT" << 'EXPECT_HEADER'
#!/usr/bin/expect -f

# Timeout for AI responses (may need adjustment for complex queries)
set timeout 120

# Log all output
log_user 1

# Spawn Claude Code
spawn claude --dangerously-skip-permissions

# Wait for initial load (look for prompt indicator)
sleep 5
EXPECT_HEADER

# Add each prompt to the expect script
for prompt in "${PROMPTS[@]}"; do
    cat >> "$EXPECT_SCRIPT" << EXPECT_PROMPT
# Send prompt with realistic typing delay
foreach char [split "$prompt" ""] {
    send -- \$char
    sleep 0.05
}
send "\r"

# Wait for response to complete
sleep 15
EXPECT_PROMPT
done

# Add exit sequence
cat >> "$EXPECT_SCRIPT" << 'EXPECT_FOOTER'
# Exit Claude
send "/exit\r"
sleep 2
expect eof
EXPECT_FOOTER

chmod +x "$EXPECT_SCRIPT"

# Record with asciinema
echo "Recording..."
asciinema rec --overwrite -c "$EXPECT_SCRIPT" "${OUTPUT}.cast"

# Cleanup
rm "$EXPECT_SCRIPT"

echo ""
echo "Recording complete: ${OUTPUT}.cast"

# Convert to GIF if agg is available
if command -v agg &> /dev/null; then
    echo "Converting to GIF..."
    agg "${OUTPUT}.cast" "${OUTPUT}.gif" --font-size 16 --cols 120 --rows 35
    echo "Created: ${OUTPUT}.gif"
fi

# Convert to MP4 if ffmpeg is available
if command -v ffmpeg &> /dev/null && [[ -f "${OUTPUT}.gif" ]]; then
    echo "Converting to MP4..."
    ffmpeg -y -i "${OUTPUT}.gif" -movflags faststart -pix_fmt yuv420p \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${OUTPUT}.mp4" 2>/dev/null
    echo "Created: ${OUTPUT}.mp4"
fi

echo ""
echo "=== Done ==="
ls -la "${OUTPUT}".*
