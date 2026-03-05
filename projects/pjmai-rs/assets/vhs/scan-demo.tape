# PJMAI Scan Workflow Demo
# Shows auto-discovery of git repositories

Output "/Users/mike/github/softwarewrighter/explainer/projects/pjmai-rs/work/vhs/scan-demo.mp4"

Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Env PJMAI_CONFIG_DIR "/tmp/pjmai-scan-demo"
Env PATH "/Users/mike/github/sw-cli-tools/pjmai-rs/target/release:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

Type "rm -rf /tmp/pjmai-scan-demo"
Enter
Sleep 200ms

Type "# PJMAI - Auto Discovery with scpj"
Enter
Sleep 500ms

Type "source /Users/mike/github/sw-cli-tools/pjmai-rs/source-pjm.sh"
Enter
Sleep 500ms

Type "# Scan directory for git repos"
Enter
Sleep 300ms

Type "pjmai-rs -y scan ~/github --depth 2 --dry-run"
Enter
Sleep 2s

Type "# Add all discovered projects"
Enter
Sleep 300ms

Type "scpj ~/github --depth 2 --add-all"
Enter
Sleep 1s

Type "# List shows grouped by organization"
Enter
Sleep 300ms

Type "lspj"
Enter
Sleep 1.5s

Type "# Switch using discovered nickname"
Enter
Sleep 300ms

Type "chpj pjmai"
Enter
Sleep 600ms

Type "pwd"
Enter
Sleep 1s
