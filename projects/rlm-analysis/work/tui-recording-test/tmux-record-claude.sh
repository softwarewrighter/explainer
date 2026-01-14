#!/bin/bash
# Record a Claude Code CLI session using tmux + asciinema
# This script creates a tmux session, runs claude, sends scripted input,
# and records everything with asciinema.

set -e

SESSION_NAME="claude-demo-$$"
OUTPUT_CAST="${1:-claude-demo.cast}"
OUTPUT_GIF="${OUTPUT_CAST%.cast}.gif"

# Cleanup function
cleanup() {
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
}
trap cleanup EXIT

echo "=== TUI Recording Script ==="
echo "Session: $SESSION_NAME"
echo "Output: $OUTPUT_CAST"
echo ""

# Create tmux session in detached mode
tmux new-session -d -s "$SESSION_NAME" -x 120 -y 30

# Start asciinema recording in the tmux session
# The trick: we run asciinema inside tmux, which records the PTY
tmux send-keys -t "$SESSION_NAME" "asciinema rec --overwrite '$OUTPUT_CAST' -c 'bash --norc'" Enter
sleep 1

# Now send the commands we want to record
# Clear and show intro
tmux send-keys -t "$SESSION_NAME" "clear" Enter
sleep 0.5

tmux send-keys -t "$SESSION_NAME" "echo '# Claude Code Demo'" Enter
sleep 1

# Start claude (using --dangerously-skip-permissions for non-interactive)
tmux send-keys -t "$SESSION_NAME" "claude --dangerously-skip-permissions" Enter
sleep 3  # Wait for claude to initialize

# Send first query
tmux send-keys -t "$SESSION_NAME" "What files are in this directory?"
sleep 0.1  # Small delay for typing effect
tmux send-keys -t "$SESSION_NAME" Enter
sleep 10  # Wait for response

# Send second query
tmux send-keys -t "$SESSION_NAME" "Show me a simple hello world in Python"
sleep 0.1
tmux send-keys -t "$SESSION_NAME" Enter
sleep 15  # Wait for response

# Exit claude
tmux send-keys -t "$SESSION_NAME" "/exit" Enter
sleep 2

# Exit the recording shell
tmux send-keys -t "$SESSION_NAME" "exit" Enter
sleep 1

echo "Recording complete!"
echo ""

# Convert to gif if agg is available
if command -v agg &> /dev/null; then
    echo "Converting to GIF..."
    agg "$OUTPUT_CAST" "$OUTPUT_GIF" --font-size 16 --cols 120 --rows 30
    echo "Created: $OUTPUT_GIF"
fi

echo ""
echo "Files created:"
ls -la "${OUTPUT_CAST}"* 2>/dev/null || true
