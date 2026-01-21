# VHS Recording Issues - rlm-llm-big Project

## The Problem

The initial VHS recording failed because the rlm command was incorrectly split across multiple `Type`/`Enter` pairs.

### Incorrect Approach (what I did wrong)

```tape
# WRONG - Each Type/Enter executes as a SEPARATE command
Type "./rlm-orchestrator/target/release/rlm /Users/mike/Downloads/war-and-peace-tolstoy-clean.txt"
Sleep 500ms
Enter
Sleep 500ms

Type "'Identify the main noble families and build their family trees...'"
Sleep 500ms
Enter
Sleep 500ms

Type "--enable-llm-delegation --enable-cli --litellm -m deepseek-coder --max-iterations 20 -vv"
Enter
```

**What happened:** Bash executed the first line as a command, which triggered the rlm help text (no query provided). Then bash tried to execute `'Identify the main...'` as a command (failed). Then bash tried to execute `--enable-llm-delegation` as a command, producing `bash: --enable-llm-delegation: command not found`.

### Correct Approach

```tape
# CORRECT - Single Type for the ENTIRE command, then ONE Enter
Type "./rlm-orchestrator/target/release/rlm /Users/mike/Downloads/war-and-peace-tolstoy-clean.txt 'Identify the main noble families and build their family trees. Show parent-child, spouse, and sibling relationships.' --enable-llm-delegation --enable-cli --litellm -m deepseek-coder --max-iterations 20 -vv"
Sleep 500ms
Enter
```

## Root Cause

I incorrectly assumed that VHS `Type` commands could span multiple lines with `Enter` between them, similar to how you might visually format a long command in documentation. In reality:

1. VHS's `Enter` command sends a literal Enter keypress to the terminal
2. Bash interprets Enter as "execute this command"
3. Each `Type` followed by `Enter` is a separate bash command

## How to Avoid This in the Future

### Rule: One Command = One Type + One Enter

For ANY bash command, no matter how long:
- Put the ENTIRE command in a single `Type "..."` statement
- Use ONE `Enter` after the complete command

### Long Commands

If a command is very long, you have two options:

**Option 1: Single long Type (preferred)**
```tape
Type "./rlm /Users/mike/Downloads/war-and-peace-tolstoy-clean.txt 'Long query here...' --flag1 --flag2 -vv"
Enter
```

**Option 2: Bash line continuation (if truly necessary)**
```tape
Type "./rlm file.txt \\"
Enter
Type "  'query' \\"
Enter
Type "  --flags"
Enter
```
Note: This requires the backslash to be part of what's typed so bash knows to continue.

### VHS Pattern Reference

From prior projects (rlm-analysis/work/tui-recording-test/README.md):

```tape
Type "claude --dangerously-skip-permissions"
Enter
Sleep 5s

Type "Your prompt here"
Enter
Sleep 10s
```

Each `Type`/`Enter` pair is ONE complete command or input.

## Wasted Time

- First recording: ~3 minutes waiting for a broken recording
- Analysis of frames: Discovered error in frame analysis
- Fix and re-record: Another ~3 minutes

Total waste: ~10 minutes + context/confusion

## Checklist for Future VHS Recordings

1. [ ] Review the full command that needs to be executed
2. [ ] Ensure the ENTIRE command fits in ONE `Type` statement
3. [ ] Never split a command across multiple `Type`/`Enter` pairs
4. [ ] Test the command manually in terminal first
5. [ ] Use `Hide`/`Show` for setup commands (env vars, cd)
