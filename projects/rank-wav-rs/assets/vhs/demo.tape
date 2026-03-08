Output work/vhs/demo.mp4

Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Hide
Type "export PATH=$PATH:~/github/softwarewrighter/rank-wav-rs/target/release"
Enter
Sleep 200ms
Type "cd ~/github/softwarewrighter/music-pipe-rs/examples/batch-20260306-122725"
Enter
Sleep 500ms
Type "clear"
Enter
Sleep 500ms
Show

# Show the wav files
Type "ls *.wav"
Enter
Sleep 2s

# Basic usage - pleasing mode (default)
Type "rank-wav ."
Enter
Sleep 4s

# Sort by best mode
Type "rank-wav . --sort best"
Enter
Sleep 4s

# JSON output with jq
Type "rank-wav . --json | jq '.[0:3] | .[] | {path, pleasing: .pleasing_score, best: .best_score}'"
Enter
Sleep 4s

Sleep 1s
