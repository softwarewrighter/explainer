# VHS Tape - Record actual Claude Code TUI interaction
# Run with: vhs claude-tui.tape
#
# This records a REAL Claude Code session with scripted input.
# VHS creates its own virtual terminal, so TUI rendering works.

Output claude-tui-demo.gif
Output claude-tui-demo.mp4

# Terminal settings - VHS creates virtual terminal, works headless!
Set FontSize 18
Set Width 1400
Set Height 900
Set Theme "Dracula"
Set Padding 20
Set TypingSpeed 50ms

# Start Claude Code with permission bypass for demo
Type "claude --dangerously-skip-permissions"
Enter
Sleep 5s

# First interaction - simple question
Type "What is 2 + 2? Answer briefly."
Enter
Sleep 8s

# Second interaction - list files
Type "List the files in the current directory"
Enter
Sleep 10s

# Third interaction - code task
Type "Write a hello world function in Python"
Enter
Sleep 12s

# Exit Claude
Type "/exit"
Enter
Sleep 2s

# Done
Type "echo 'Demo complete!'"
Enter
Sleep 1s
