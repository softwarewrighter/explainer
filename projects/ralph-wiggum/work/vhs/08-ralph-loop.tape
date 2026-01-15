Output ralphloop.mp4
Set FontSize 28
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 35ms
Set Padding 40

Type "cd ~/github/softwarewrighter/test-ralph"
Enter
Sleep 1s
Type "# Start the Ralph Wiggum loop"
Enter
Sleep 500ms
Type "claude --dangerously-skip-permissions"
Enter
Sleep 5s
Type@100ms "/ralph-loop \"$(cat PROMPT.md)\" --max-iterations 8 --completion-promise TESTS_COMPLETE"
Enter
Sleep 45s
