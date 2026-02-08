Output work/clips/04-cli-demo-raw.mp4
Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

Hide
Type "cd ~/github/sw-comp-history/pipelines-rs && alias pipe=target/release/pipe-run-rat"
Enter
Sleep 500ms
Show

# Show a few input records
Type "head -4 specs/input-fixed-80.data"
Enter
Sleep 2s

# Demo 1: Filter SALES department
Type "cat specs/filter-sales.pipe"
Enter
Sleep 2s

Type "pipe -v specs/filter-sales.pipe specs/input-fixed-80.data"
Enter
Sleep 3s

# Demo 2: Sales report (filter + select name+salary)
Type "cat specs/sales-report.pipe"
Enter
Sleep 2s

Type "pipe -v specs/sales-report.pipe specs/input-fixed-80.data"
Enter
Sleep 3s

# Demo 3: Three-stage pipeline ending in count
Type "cat specs/multi-filter-count.pipe"
Enter
Sleep 2s

Type "pipe -v specs/multi-filter-count.pipe specs/input-fixed-80.data"
Enter
Sleep 3s
