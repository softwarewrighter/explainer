Output promptmd.mp4
Set FontSize 28
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 30ms
Set Padding 40

Type "cd ~/github/softwarewrighter/test-ralph"
Enter
Sleep 1s
Type "cat > PROMPT.md << 'EOF'"
Enter
Type "# Task: Add Unit Tests for CardList Component"
Enter
Enter
Type "## Goal"
Enter
Type "Add comprehensive wasm-bindgen tests for src/components/card_list.rs"
Enter
Enter
Type "## Requirements"
Enter
Type "1. Test CardListProps creation and validation"
Enter
Type "2. Test rendering with empty card list"
Enter
Type "3. Test rendering with multiple cards"
Enter
Type "4. Test callback functions (on_edit, on_delete, on_select)"
Enter
Type "5. Test selection highlighting behavior"
Enter
Type "6. All tests must pass with wasm-pack test"
Enter
Enter
Type "## Completion Criteria"
Enter
Type "When ALL requirements are met and tests pass, output:"
Enter
Type "<promise>TESTS_COMPLETE</promise>"
Enter
Type "EOF"
Enter
Sleep 2s
Type "cat PROMPT.md"
Enter
Sleep 6s
