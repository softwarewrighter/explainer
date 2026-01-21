# Favicon CLI - Part 2: AI Fixes What AI Found

## Video Concept
Part 2 follows up on the bug discovery video. Claude Code now fixes every bug and implements every feature it found in Part 1.

## Structure (~10-12 minutes)

### 1. Title (7s)
- Heart image 2s + Title slide 5s
- Music: soaring.mp3

### 2. Hook (15-20s)
"Yesterday, we watched Claude Code discover 6 bugs, 2 missing features, and a documentation gap in my favicon CLI tool. Today, it fixes every single one."

### 3. Recap (30s)
Quick recap of what was found:
- 6 Bugs: Named colors, transparent, PNG filename, animation defaults, wrench symbol, unicode code points
- 2 Features: --list-symbols, color format examples
- 1 Doc gap: Emoji font requirements

### 4. Bug Fixes (6-7 minutes)

#### Bug #1: Named Colors (60s)
- Show failing command: `favicon --symbol A --fg red --bg blue`
- Claude adds csscolorparser crate or color lookup table
- Show working result

#### Bug #2: Transparent Color (45s)
- Show failing command: `favicon --symbol A --fg white --bg transparent`
- Add special case for "transparent" keyword
- Verify PNG transparency

#### Bug #3: PNG Filename (30s)
- Show current confusing behavior
- Fix --output flag handling
- Default to "favicon.png"

#### Bug #4: Animation Speed (30s)
- Update --help with default values
- Add validation with helpful errors

#### Bug #5: Wrench Symbol (45s)
- Show "wrench" rendering as text
- Add symbol name to emoji mapping
- Show wrench icon rendering correctly

#### Bug #6: Unicode Code Points (60s)
- Show U+2764 failing
- Add code point parsing (U+XXXX and plain hex)
- Show heart emoji rendering

### 5. Feature Implementation (2-3 minutes)

#### Feature #1: --list-symbols (60s)
- Add --list-symbols flag
- Create symbol registry
- Show categorized output

#### Feature #2: Color Format Help (30s)
- Update --help with color examples
- Show #RGB, #RRGGBB, named, transparent

### 6. Documentation (60s)
- Add emoji font requirements to README
- Installation instructions for each OS
- Troubleshooting guide

### 7. Verification (60s)
Run full test checklist:
```bash
# All tests from favicon-todo.txt
favicon --symbol A --fg red --bg blue -o test1.png
favicon --symbol A --fg white --bg transparent -o test2.png
favicon --symbol wrench -o test5.png
favicon --symbol U+2764 -o test6.png
favicon --list-symbols
```

### 8. CTA (20s)
- Subscribe for more AI-powered development
- Link to repo
- Part 3 teaser: "What bugs will it find next?"

### 9. Epilog (12s)
- Reference epilog + 5s music extension

## Assets Needed

### SVG Slides
- 00-title.svg - Title slide
- 02-hook.svg - Hook text
- 03-recap.svg - Bug list recap
- 10-bug1.svg through 60-bug6.svg - Bug fix slides
- 70-feature1.svg, 75-feature2.svg - Feature slides
- 80-docs.svg - Documentation slide
- 90-verify.svg - Verification checklist
- 95-cta.svg - Call to action

### OBS Recording
- Screen recording of Claude Code fixing bugs
- Terminal showing test commands and results

### Scripts (TTS)
- Narration for each section

## Notes
- Same avatar: curmudgeon.mp4
- Same music: soaring.mp3
- Same epilog pattern as Part 1
- CRITICAL: Normalize all audio to 44100 Hz stereo, -25 dB before concat
