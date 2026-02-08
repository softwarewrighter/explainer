Output work/clips/04b-cli-demo-raw.mp4
Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Hide
Type "cd ~/github/sw-comp-history/pipelines-rs"
Enter
Sleep 500ms
Show

# Brief look at CLI docs
Type "head -6 naive-pipe/docs/cli-usage.md"
Enter
Sleep 1500ms

# Show help
Type "target/release/pipe-run-rat -h"
Enter
Sleep 1500ms

# Show input data
Type "head -4 specs/input-fixed-80.data"
Enter
Sleep 1500ms

# Show the CHANGE pipe spec
Type "cat specs/change-rename.pipe"
Enter
Sleep 1500ms

# Run with -v to show paths, executor, record counts
Type "target/release/pipe-run-rat -v specs/change-rename.pipe specs/input-fixed-80.data"
Enter
Sleep 2500ms

# Set up alias for inline use
Type "alias pipe=target/release/pipe-run-rat"
Enter
Sleep 500ms

# Inline pipe spec + inline data
Type "pipe <(echo 'PIPE CONSOLE | UPPER | CONSOLE ?') <(printf 'hello\nworld\n')"
Enter
Sleep 2s

# Same with -v flag showing record counts
Type "pipe -v <(echo 'PIPE CONSOLE | UPPER | CONSOLE ?') <(printf 'hello\nworld\n')"
Enter
Sleep 2500ms
