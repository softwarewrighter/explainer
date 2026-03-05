# PJMAI Stack Navigation Demo
# Shows push/pop workflow

Output "/Users/mike/github/softwarewrighter/explainer/projects/pjmai-rs/work/vhs/stack-demo.mp4"

Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Env PJMAI_CONFIG_DIR "/tmp/pjmai-stack-demo"
Env PATH "/Users/mike/github/sw-cli-tools/pjmai-rs/target/release:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

Type "rm -rf /tmp/pjmai-stack-demo /tmp/projects"
Enter
Sleep 200ms

Type "mkdir -p /tmp/projects/webapp /tmp/projects/api /tmp/projects/config"
Enter
Sleep 200ms

Type "# PJMAI - Stack Navigation"
Enter
Sleep 500ms

Type "source /Users/mike/github/sw-cli-tools/pjmai-rs/source-pjm.sh"
Enter
Sleep 500ms

Type "# Setup: add three projects"
Enter
Sleep 300ms

Type "pjmai-rs -y add -p webapp -f /tmp/projects/webapp && adpj api -f /tmp/projects/api && adpj config -f /tmp/projects/config"
Enter
Sleep 500ms

Type "# Working in webapp"
Enter
Sleep 300ms

Type "chpj webapp"
Enter
Sleep 400ms

Type "# Need to check API, push current"
Enter
Sleep 300ms

Type "pspj api"
Enter
Sleep 600ms

Type "shpj"
Enter
Sleep 800ms

Type "# Need to check config too"
Enter
Sleep 300ms

Type "pspj config"
Enter
Sleep 600ms

Type "shpj"
Enter
Sleep 800ms

Type "# Done, pop back to api"
Enter
Sleep 300ms

Type "popj"
Enter
Sleep 600ms

Type "prpj"
Enter
Sleep 500ms

Type "# Pop back to webapp"
Enter
Sleep 300ms

Type "popj"
Enter
Sleep 600ms

Type "prpj"
Enter
Sleep 1s
