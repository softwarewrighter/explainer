Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Output recordings/cli-03-dogfood.mp4

# Setup: PATH, aliases, clean workspace
Hide
Type "export PATH=/Users/mike/github/sw-cli-tools/reg-rs/components/app/target/release:$PATH && export REG_RS_DATA_DIR=/tmp/reg-rs-demo && mkdir -p $REG_RS_DATA_DIR && rm -f $REG_RS_DATA_DIR/rg_* && export RUST_LOG=error && source /Users/mike/github/sw-cli-tools/reg-rs/bin/source-rg.sh"
Enter
Sleep 1s
Type "clear"
Enter
Sleep 500ms
Show

# Create self-tests using aliases
Type "adrg rg_help 'reg-rs -h'"
Enter
Sleep 2s

Type "adrg rg_create_help 'reg-rs create -h'"
Enter
Sleep 2s

Type "adrg rg_run_help 'reg-rs run -h'"
Enter
Sleep 2s

Type "adrg rg_show_help 'reg-rs show -h'"
Enter
Sleep 2s

# Run all self-tests
Type "rnrg rg_"
Enter
Sleep 3s

# List results
Type "lsrg rg_"
Enter
Sleep 3s

# Clean up
Type "rmrg rg_"
Enter
Sleep 2s

Sleep 1s

# Hidden cleanup
Hide
Type "rm -rf $REG_RS_DATA_DIR"
Enter
Sleep 500ms
