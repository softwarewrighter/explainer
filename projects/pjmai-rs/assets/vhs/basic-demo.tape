# PJMAI Basic Workflow Demo
# Shows core commands: add, list, switch, show

Output "/Users/mike/github/softwarewrighter/explainer/projects/pjmai-rs/work/vhs/basic-demo.mp4"

Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Env PJMAI_CONFIG_DIR "/tmp/pjmai-demo"
Env PATH "/Users/mike/github/sw-cli-tools/pjmai-rs/target/release:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

Type "rm -rf /tmp/pjmai-demo /tmp/projects"
Enter
Sleep 200ms

Type "mkdir -p /tmp/projects/webapp /tmp/projects/backend /tmp/projects/config"
Enter
Sleep 200ms

Type "# PJMAI - Project Management CLI"
Enter
Sleep 500ms

Type "source /Users/mike/github/sw-cli-tools/pjmai-rs/source-pjm.sh"
Enter
Sleep 500ms

Type "# Add projects with short nicknames"
Enter
Sleep 300ms

Type "pjmai-rs -y add -p webapp -f /tmp/projects/webapp"
Enter
Sleep 400ms

Type "adpj backend -f /tmp/projects/backend"
Enter
Sleep 400ms

Type "adpj config -f /tmp/projects/config"
Enter
Sleep 500ms

Type "# List all projects"
Enter
Sleep 300ms

Type "lspj"
Enter
Sleep 1s

Type "# Switch with fuzzy matching"
Enter
Sleep 300ms

Type "chpj back"
Enter
Sleep 400ms

Type "pwd"
Enter
Sleep 600ms

Type "# Show current project"
Enter
Sleep 300ms

Type "shpj"
Enter
Sleep 1s

Type "# Get project name for prompt"
Enter
Sleep 300ms

Type "prpj"
Enter
Sleep 1s
