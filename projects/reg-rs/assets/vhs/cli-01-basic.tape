Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Output recordings/cli-01-basic.mp4

# Setup: PATH, aliases, clean workspace
Hide
Type "export PATH=/Users/mike/github/sw-cli-tools/reg-rs/components/app/target/release:$PATH && export REG_RS_DATA_DIR=/tmp/reg-rs-demo && mkdir -p $REG_RS_DATA_DIR && rm -f $REG_RS_DATA_DIR/hello.* && export RUST_LOG=error && source /Users/mike/github/sw-cli-tools/reg-rs/bin/source-rg.sh"
Enter
Sleep 1s
Type "clear"
Enter
Sleep 500ms
Show

# Create a test using alias
Type "adrg hello 'echo hello world'"
Enter
Sleep 2s

# Run the test
Type "rnrg hello"
Enter
Sleep 2s

# List results
Type "lsrg hello"
Enter
Sleep 2s

# Show details
Type "shrg hello"
Enter
Sleep 3s

# Clean up
Type "rmrg hello"
Enter
Sleep 2s

Sleep 1s

# Hidden cleanup
Hide
Type "rm -rf $REG_RS_DATA_DIR"
Enter
Sleep 500ms
