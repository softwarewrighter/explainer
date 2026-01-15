Output testcount.mp4
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 40

Type "cd ~/github/softwarewrighter/test-ralph"
Enter
Sleep 1s
Type "# Check current test count"
Enter
Sleep 500ms
Type "wasm-pack test --headless --chrome 2>&1 | grep -E '(running|passed|test result)'"
Enter
Sleep 12s
Type "# How many tests in card_list.rs?"
Enter
Sleep 500ms
Type "grep -c '#\\[wasm_bindgen_test\\]' src/components/card_list.rs || echo '0 tests in card_list.rs'"
Enter
Sleep 3s
Type "# 101 lines of code, zero tests!"
Enter
Sleep 2s
