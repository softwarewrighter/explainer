# VHS Tape: L4 Detective Mystery Demo
# Records the detective-demo.sh for the RLM LLM explainer video
# Run from: /Users/mike/github/softwarewrighter/rlm-project
#
# Note: Uses export $(cat ~/.env | grep -v '^#' | xargs) pattern
# to load environment variables (LITELLM_MASTER_KEY etc)
#
# Demo takes ~3 minutes to complete

Output l4-detective-demo.mp4

Set Shell "bash"
Set FontSize 18
Set Width 1920
Set Height 1080
Set TypingSpeed 50ms
Set Theme "Dracula"

Sleep 500ms

# Export env vars and run demo (reliable pattern from rlm-project scripts)
Type "export $(cat ~/.env | grep -v '^#' | xargs) && ./demo/l4/detective-demo.sh"
Enter

# Wait for the demo to complete (~3 minutes + buffer)
Sleep 210s
