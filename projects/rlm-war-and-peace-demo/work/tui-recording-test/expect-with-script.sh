#!/bin/bash
# Combined approach: Use 'script' command to record PTY + expect for automation
# This captures ALL terminal output including TUI escape sequences

set -e

OUTPUT_FILE="${1:-session.typescript}"
OUTPUT_CAST="${2:-session.cast}"

echo "=== Expect + Script Recording ==="
echo "This uses 'script' to capture raw terminal output"
echo ""

# Create the expect script inline
cat > /tmp/auto-session.exp << 'EXPECT_SCRIPT'
#!/usr/bin/expect -f

# Disable timeout for long-running commands
set timeout 120

# Log everything
log_user 1

# Spawn a shell that we'll interact with
spawn bash --norc --noprofile

# Wait for shell prompt
expect -re {\$ }

# Clear screen
send "clear\r"
expect -re {\$ }

# Show what we're doing
send "echo '# AI CLI Demo Session'\r"
expect -re {\$ }
sleep 1

# Try a simple command first
send "ls -la\r"
expect -re {\$ }
sleep 1

# Now try the AI CLI (claude)
# Note: TUIs may not work well with expect due to complex rendering
send "claude --dangerously-skip-permissions --print 'What is 2+2?' 2>/dev/null || echo 'Claude not available in this mode'\r"
expect {
    -re {\$ } { }
    timeout { send "\x03" }
}
sleep 2

send "echo 'Demo complete!'\r"
expect -re {\$ }

send "exit\r"
expect eof
EXPECT_SCRIPT

chmod +x /tmp/auto-session.exp

# Use 'script' to record everything, running expect inside
echo "Starting recording..."
script -q "$OUTPUT_FILE" /tmp/auto-session.exp

echo ""
echo "Recording saved to: $OUTPUT_FILE"
echo ""

# Try to convert to asciinema format if possible
if [ -f "$OUTPUT_FILE" ]; then
    echo "Raw typescript saved. Size: $(wc -c < "$OUTPUT_FILE") bytes"
    # Note: Converting script output to asciinema format requires additional tooling
fi
