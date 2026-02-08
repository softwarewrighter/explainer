# Sleepy Coder CLI Demo
# VHS tape for recording the agent in action

# Required VHS Settings
Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

# Intro - show help
Type "cd ~/github/softwarewrighter/sleepy-coder"
Enter
Sleep 500ms

Type "cargo run --release -p cli -- --help"
Enter
Sleep 3s

# List available koans
Type "cargo run --release -p cli -- list"
Enter
Sleep 4s

# Show a specific koan
Type "cargo run --release -p cli -- show borrow_001"
Enter
Sleep 3s

# Run the agent on a few koans (requires Ollama running)
Type "# Run agent on 3 borrow checker koans"
Enter
Sleep 500ms

Type "cargo run --release -p cli -- run --count 3 --family borrow"
Enter
Sleep 15s

# Pause to show results
Sleep 3s
