# VHS Tape - RLM Level 2 WASM: Error Type Frequency
# Run with: vhs projects/rlm-wasm/work/vhs/l2-error-ranking.tape

Output projects/rlm-wasm/work/vhs/l2-error-ranking.gif
Output projects/rlm-wasm/work/vhs/l2-error-ranking.mp4

Set FontSize 22
Set Width 1600
Set Height 1000
Set Theme "Dracula"
Set Padding 20
Set TypingSpeed 40ms

# Title
Type "# RLM Level 2: Error Type Frequency (WASM)"
Enter
Sleep 1s
Enter

# Run the demo
Type "cd rlm-orchestrator"
Enter
Sleep 500ms

Type "./demos/l2/error-ranking.sh"
Enter
Sleep 45s

Enter
Sleep 2s
