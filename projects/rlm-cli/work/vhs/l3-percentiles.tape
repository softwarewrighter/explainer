# VHS Tape: L3 CLI Percentiles Demo
# Records the percentiles.sh demo for the RLM CLI explainer video
# Run from: /Users/mike/github/softwarewrighter/rlm-project
#
# Note: Uses export $(cat ~/.env | grep -v '^#' | xargs) pattern
# to load environment variables (LITELLM_MASTER_KEY etc)

Output l3-percentiles.mp4

Set Shell "bash"
Set FontSize 18
Set Width 1920
Set Height 1080
Set TypingSpeed 50ms
Set Theme "Dracula"

Sleep 500ms

# Export env vars and run demo (reliable pattern from rlm-project scripts)
Type "export $(cat ~/.env | grep -v '^#' | xargs) && ./demo/l3/percentiles.sh"
Enter

# Wait for the demo to complete
Sleep 90s
