Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Output /Users/mike/github/softwarewrighter/explainer/projects/saw-pjm-rig/work/recordings/rig-demo.mp4

Sleep 500ms

Type "cd ~/github/softwarewrighter/try-rig"
Enter
Sleep 500ms

Type "# Exploring the Rig crate for AI agents in Rust"
Enter
Sleep 1s

Type "./target/release/try-rig --help"
Enter
Sleep 4s

Type "# Simple question to Ollama via Rig"
Enter
Sleep 1s

Type "./target/release/try-rig ask 'What are three benefits of writing AI agents in Rust?'"
Enter
Sleep 12s

Type "# Tool-equipped agent with calculator"
Enter
Sleep 1s

Type "./target/release/try-rig tools 'What is 234 times 567?'"
Enter
Sleep 10s

Type "# RAG with in-memory vector store"
Enter
Sleep 1s

Type "./target/release/try-rig rag 'What is TCP and how does it work?'"
Enter
Sleep 12s
