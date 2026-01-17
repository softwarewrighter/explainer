# VHS Tape - RLM Level 2 WASM: Unique IP Count
# Run with: vhs projects/rlm-wasm/work/vhs/l2-unique-ips.tape (from explainer dir)

Output projects/rlm-wasm/work/vhs/l2-unique-ips.gif
Output projects/rlm-wasm/work/vhs/l2-unique-ips.mp4

Set FontSize 22
Set Width 1600
Set Height 1000
Set Theme "Dracula"
Set Padding 20
Set TypingSpeed 40ms

# Title
Type "# RLM Level 2: Unique IP Count (WASM)"
Enter
Sleep 1s
Enter

# Run the demo
Type "cd ../rlm-project/rlm-orchestrator"
Enter
Sleep 500ms

Type "./demos/l2/unique-ips.sh"
Enter
Sleep 45s

Enter
Sleep 2s
