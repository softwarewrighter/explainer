Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Output recordings/cli-02-regression.mp4

# Setup: PATH, aliases, clean workspace
Hide
Type "export PATH=/Users/mike/github/sw-cli-tools/reg-rs/components/app/target/release:$PATH && export REG_RS_DATA_DIR=/tmp/reg-rs-demo && mkdir -p $REG_RS_DATA_DIR/testdata && rm -rf $REG_RS_DATA_DIR/version_test.* $REG_RS_DATA_DIR/testdata/* && export RUST_LOG=error && source /Users/mike/github/sw-cli-tools/reg-rs/bin/source-rg.sh"
Enter
Sleep 1s
Type "clear"
Enter
Sleep 500ms
Show

# Create baseline
Type "echo 'version 1.0.0' > $REG_RS_DATA_DIR/testdata/version.txt"
Enter
Sleep 1s

Type "adrg version_test 'cat $REG_RS_DATA_DIR/testdata/version.txt'"
Enter
Sleep 2s

# Run test - should pass
Type "rnrg version_test"
Enter
Sleep 2s

# Simulate regression
Type "echo 'version 2.0.0' > $REG_RS_DATA_DIR/testdata/version.txt"
Enter
Sleep 1s

# Run again - should fail with inline diff
Type "rnrg version_test -vv"
Enter
Sleep 4s

# Accept the new output
Type "uprg version_test"
Enter
Sleep 2s

# Run again - should pass now
Type "rnrg version_test"
Enter
Sleep 2s

Sleep 1s

# Hidden cleanup
Hide
Type "rm -rf $REG_RS_DATA_DIR"
Enter
Sleep 500ms
