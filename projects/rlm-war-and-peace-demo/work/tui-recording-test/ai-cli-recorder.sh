#!/bin/bash
# AI CLI Recorder - Records scripted AI CLI interactions
# Supports: claude, opencode, gemini (with appropriate adaptations)
#
# Usage: ./ai-cli-recorder.sh [options]
#   --cli <name>       CLI to record (claude, opencode, gemini)
#   --mode <mode>      Recording mode: tui (default), print (non-interactive)
#   --script <file>    Script file with prompts (one per line)
#   --output <name>    Output filename base (default: ai-demo)
#   --delay <seconds>  Delay between prompts (default: 5)

set -e

# Defaults
CLI="claude"
MODE="tui"
SCRIPT_FILE=""
OUTPUT="ai-demo"
DELAY=5
PROMPTS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --cli) CLI="$2"; shift 2 ;;
        --mode) MODE="$2"; shift 2 ;;
        --script) SCRIPT_FILE="$2"; shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        --delay) DELAY="$2"; shift 2 ;;
        --prompt) PROMPTS+=("$2"); shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

# Load prompts from file if specified
if [[ -n "$SCRIPT_FILE" && -f "$SCRIPT_FILE" ]]; then
    while IFS= read -r line; do
        [[ -n "$line" && ! "$line" =~ ^# ]] && PROMPTS+=("$line")
    done < "$SCRIPT_FILE"
fi

# Default prompts if none specified
if [[ ${#PROMPTS[@]} -eq 0 ]]; then
    PROMPTS=(
        "What files are in this directory?"
        "Show me a simple hello world in Python"
    )
fi

echo "=== AI CLI Recorder ==="
echo "CLI: $CLI"
echo "Mode: $MODE"
echo "Output: $OUTPUT"
echo "Prompts: ${#PROMPTS[@]}"
echo ""

# Function to record using print mode (non-TUI)
record_print_mode() {
    local cast_file="${OUTPUT}.cast"

    echo "Recording in print mode (non-interactive)..."

    # Create a script that runs the prompts
    local script_file="/tmp/print-session-$$.sh"
    cat > "$script_file" << 'SCRIPT_HEADER'
#!/bin/bash
clear
echo "# AI CLI Demo (Print Mode)"
echo ""
sleep 1
SCRIPT_HEADER

    for prompt in "${PROMPTS[@]}"; do
        cat >> "$script_file" << SCRIPT_BODY
echo "─────────────────────────────────────────────"
echo "User: $prompt"
echo ""
$CLI --print "$prompt" --dangerously-skip-permissions 2>/dev/null || echo "(Response would appear here)"
echo ""
sleep 2
SCRIPT_BODY
    done

    echo 'echo "Demo complete!"' >> "$script_file"
    chmod +x "$script_file"

    # Record with asciinema
    asciinema rec --overwrite -c "$script_file" "$cast_file"
    rm "$script_file"

    echo "Recorded: $cast_file"
}

# Function to record using TUI mode with expect
record_tui_expect() {
    local cast_file="${OUTPUT}.cast"
    local exp_file="/tmp/tui-session-$$.exp"

    echo "Recording in TUI mode using expect..."

    # Generate expect script
    cat > "$exp_file" << 'EXP_HEADER'
#!/usr/bin/expect -f
set timeout 120
log_user 1

# Start the CLI
EXP_HEADER

    echo "spawn $CLI --dangerously-skip-permissions" >> "$exp_file"
    echo 'sleep 3' >> "$exp_file"
    echo '' >> "$exp_file"

    for prompt in "${PROMPTS[@]}"; do
        cat >> "$exp_file" << EXP_BODY
# Send prompt
send "$prompt\r"
sleep $DELAY

EXP_BODY
    done

    cat >> "$exp_file" << 'EXP_FOOTER'
# Exit
send "/exit\r"
expect eof
EXP_FOOTER

    chmod +x "$exp_file"

    # Record with asciinema running expect
    asciinema rec --overwrite -c "$exp_file" "$cast_file"
    rm "$exp_file"

    echo "Recorded: $cast_file"
}

# Function to record using TUI mode with tmux (more reliable for complex TUIs)
record_tui_tmux() {
    local cast_file="${OUTPUT}.cast"
    local session="ai-record-$$"

    echo "Recording in TUI mode using tmux..."
    echo "(This requires running in a real terminal)"

    # Check if we have a TTY
    if [ ! -t 0 ]; then
        echo "ERROR: TUI recording requires a real terminal (TTY)"
        echo "Try: ./ai-cli-recorder.sh --mode print"
        exit 1
    fi

    # Create tmux session
    tmux new-session -d -s "$session" -x 120 -y 30

    # Start recording inside tmux
    tmux send-keys -t "$session" "asciinema rec --overwrite '$cast_file'" Enter
    sleep 1

    # Start the CLI
    tmux send-keys -t "$session" "$CLI --dangerously-skip-permissions" Enter
    sleep 3

    # Send each prompt
    for prompt in "${PROMPTS[@]}"; do
        # Type the prompt character by character for realistic effect
        tmux send-keys -t "$session" -l "$prompt"
        sleep 0.5
        tmux send-keys -t "$session" Enter
        sleep "$DELAY"
    done

    # Exit CLI
    tmux send-keys -t "$session" "/exit" Enter
    sleep 2

    # Stop recording
    tmux send-keys -t "$session" "exit" Enter
    sleep 1

    # Kill session
    tmux kill-session -t "$session" 2>/dev/null || true

    echo "Recorded: $cast_file"
}

# Main execution
case "$MODE" in
    print)
        record_print_mode
        ;;
    tui-expect|expect)
        record_tui_expect
        ;;
    tui|tmux)
        record_tui_tmux
        ;;
    *)
        echo "Unknown mode: $MODE"
        echo "Valid modes: print, tui-expect, tui (tmux)"
        exit 1
        ;;
esac

# Convert to GIF if possible
if command -v agg &> /dev/null && [[ -f "${OUTPUT}.cast" ]]; then
    echo ""
    echo "Converting to GIF..."
    agg "${OUTPUT}.cast" "${OUTPUT}.gif" --font-size 16 --cols 120 --rows 30
    echo "Created: ${OUTPUT}.gif"
fi

# Convert to MP4 if possible
if command -v ffmpeg &> /dev/null && [[ -f "${OUTPUT}.gif" ]]; then
    echo "Converting to MP4..."
    ffmpeg -y -i "${OUTPUT}.gif" -movflags faststart -pix_fmt yuv420p \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${OUTPUT}.mp4" 2>/dev/null
    echo "Created: ${OUTPUT}.mp4"
fi

echo ""
echo "=== Recording Complete ==="
ls -la "${OUTPUT}".*
