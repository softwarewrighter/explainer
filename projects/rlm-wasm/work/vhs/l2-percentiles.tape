# VHS Tape - RLM Level 2 WASM: Response Time Percentiles
# Run with: vhs l2-percentiles.tape (from this directory)

Output projects/rlm-wasm/work/vhs/l2-percentiles.gif
Output projects/rlm-wasm/work/vhs/l2-percentiles.mp4

Set FontSize 22
Set Width 1600
Set Height 1000
Set Theme "Dracula"
Set Padding 20
Set TypingSpeed 40ms

# Title
Type "# RLM Level 2: Response Time Percentiles (WASM)"
Enter
Sleep 1s
Enter

# Run the demo
Type "cd ../rlm-project/rlm-orchestrator"
Enter
Sleep 500ms

Type "./demos/l2/percentiles.sh"
Enter
Sleep 45s

Enter
Sleep 2s
