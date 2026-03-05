# PJMAI Environment Management Demo
# Shows env config and .pjmai.sh approval

Output "/Users/mike/github/softwarewrighter/explainer/projects/pjmai-rs/work/vhs/env-demo.mp4"

Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Env PJMAI_CONFIG_DIR "/tmp/pjmai-env-demo"
Env PATH "/Users/mike/github/sw-cli-tools/pjmai-rs/target/release:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

Type "rm -rf /tmp/pjmai-env-demo /tmp/projects"
Enter
Sleep 200ms

Type "mkdir -p /tmp/projects/webapp"
Enter
Sleep 200ms

Type "# PJMAI - Environment Management"
Enter
Sleep 500ms

Type "source /Users/mike/github/sw-cli-tools/pjmai-rs/source-pjm.sh"
Enter
Sleep 500ms

Type "# First add a project"
Enter
Sleep 300ms

Type "pjmai-rs -y add -p webapp -f /tmp/projects/webapp"
Enter
Sleep 400ms

Type "# Set env variable for a project"
Enter
Sleep 300ms

Type "evpj webapp set DATABASE_URL postgres://localhost/webapp"
Enter
Sleep 600ms

Type "# Add on-enter hook"
Enter
Sleep 300ms

Type "evpj webapp on-enter 'echo Activating webapp'"
Enter
Sleep 600ms

Type "# Show project environment config"
Enter
Sleep 300ms

Type "evpj webapp show"
Enter
Sleep 1s

Type "# Create .pjmai.sh in project"
Enter
Sleep 300ms

Type "echo 'export SRCROOT=$PWD' > /tmp/projects/webapp/.pjmai.sh"
Enter
Sleep 400ms

Type "# Switch to project - shows approval warning"
Enter
Sleep 300ms

Type "chpj webapp"
Enter
Sleep 800ms

Type "# Approve and source with srcpj"
Enter
Sleep 300ms

Type "srcpj"
Enter
Sleep 1s
