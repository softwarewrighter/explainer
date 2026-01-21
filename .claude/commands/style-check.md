---
description: Validate video assets against style guide
argument-hint: [file-or-directory]
allowed-tools: Read, Grep, Glob, Bash
---

# Style Guide Validation

Validate video assets against the mandatory style guide at `/docs/style-guide.md`.

## Target

Check: $ARGUMENTS

If no target specified, check all assets in the current project.

## Validation Rules

### For SVG Files (.svg)

Check font-size attributes:
- Headlines must be >= 84px (recommend 96px)
- Subtitles must be >= 42px (recommend 48px)
- Body text must be >= 32px (recommend 36px)
- All other text must be >= 28px
- **FAIL if any font-size is below 28px**

Check stroke-width attributes:
- All stroke-widths must be >= 4px (recommend 5px)
- **FAIL if any stroke-width is below 4px**

### For VHS Tape Files (.tape)

Check settings:
- FontSize must be >= 18 (recommend 24)
- **FAIL if FontSize is below 18**
- Width should be 1920
- Height should be 1080
- Theme should be "Dracula"

Check command patterns:
- Warn if commands appear to be split across multiple Type/Enter pairs

### For TTS Script Files (.txt in work/scripts/)

Check content:
- Must be <= 320 characters
- Must not contain digits (0-9)
- Must not contain forbidden punctuation: ' - — – ! ? ; : " ' / @
- **FAIL if any violations found**

## Output Format

Report findings as:

```
=== STYLE CHECK RESULTS ===

✓ PASS: filename - all checks passed
✗ FAIL: filename - [specific violation]
⚠ WARN: filename - [recommendation]

Summary: X passed, Y failed, Z warnings
```

## Instructions

1. Use Glob to find target files
2. Use Read or Grep to check each file
3. Compare values against style guide requirements
4. Report all violations clearly
5. Suggest fixes for each violation

Be thorough. Check EVERY file. Report EVERY violation.
