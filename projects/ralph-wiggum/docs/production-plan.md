# Ralph Wiggum Video Production Plan

## Overview
Create a 3-4 minute explainer video demonstrating the Ralph Wiggum technique using real tools, real code, and real iterations.

**Demo Project:** ~/github/softwarewrighter/test-ralph (Rolodex 3D - Rust/WASM contact app)
**Demo Task:** Add comprehensive unit tests for CardList component (0 → 6+ tests)

## Asset Capture Tools

| Asset Type | Tool | Output |
|------------|------|--------|
| CLI demos | VHS (charmbracelet/vhs) | .mp4 |
| Web UI captures | MCP Playwright | .png → .mp4 |
| Diagrams | Claude SVG generation | .svg → .mp4 |
| Avatar clips | TTS + Lipsync | .mp4 |

---

## Segment-by-Segment Production Plan

### Segment 01: Hook (Avatar)
**Duration:** 10s
**Narration:** "What if you could ship six repos overnight for under three hundred dollars? Or complete a fifty thousand dollar contract for two ninety seven? The Ralph Wiggum technique makes this possible."

**Assets:**
- [ ] SVG background: Glowing "$50K → $297" with loop icon
- [ ] TTS narration
- [ ] Avatar lipsync

**Production Steps:**
```bash
# 1. Generate SVG background
claude --print "Generate SVG (1920x1080, dark bg #0a0512): Large glowing text '$50K → $297' in gold (#d4af37), subtitle 'The Ralph Wiggum Technique', infinite loop icon" > work/svg/01-hook-bg.svg

# 2. Generate TTS
vid-tts --text "What if you could ship six repos..." --output work/audio/01-hook.wav

# 3. Create background video
vid-image --input work/svg/01-hook-bg.svg --duration 12 --output work/clips/01-hook-bg.mp4

# 4. Lipsync avatar (on hive server)
vid-lipsync --avatar curmudgeon.mp4 --audio work/audio/01-hook.wav --output work/clips/01-hook-avatar.mp4

# 5. Composite
vid-composite --background work/clips/01-hook-bg.mp4 --avatar work/clips/01-hook-avatar.mp4 --output work/clips/01-hook.mp4
```

---

### Segment 02: The Problem (Diagram)
**Duration:** 15s
**Narration:** "Working with A I coding assistants usually means constant back and forth. You prompt. You wait. You review. You find errors. You correct. You prompt again. This manual iteration takes hours and requires your constant attention."

**Assets:**
- [ ] SVG diagram: Developer ↔ AI ping-pong with clock

**Production Steps:**
```bash
# 1. Generate SVG diagram
claude --print "Generate SVG (1920x1080, dark bg): Left side shows developer icon, right side shows AI/robot icon. Multiple arrows going back and forth between them. Clock showing hours passing. Red X marks scattered. Text: 'Manual Iteration = Hours of Attention'" > work/svg/02-problem.svg

# 2. Generate TTS
vid-tts --text "Working with A I coding assistants..." --output work/audio/02-problem.wav

# 3. Convert to video (duration from TTS)
vid-image --input work/svg/02-problem.svg --duration 17 --output work/clips/02-problem.mp4

# 4. Mix audio
ffmpeg -i work/clips/02-problem.mp4 -i work/audio/02-problem.wav -c:v copy -c:a aac -map 0:v -map 1:a work/clips/02-problem-final.mp4
```

---

### Segment 03: The Core Technique (Diagram + CLI)
**Duration:** 20s
**Narration:** "The Ralph Wiggum technique flips this completely. Named after the Simpsons character who keeps trying despite setbacks. The core idea is brilliantly simple. Put Claude in a while loop. While true. Cat prompt dot M D. Pipe to Claude Code. Done. The prompt never changes. But Claude sees its previous work in files and git. Each iteration it reads what it built and improves."

**Assets:**
- [ ] SVG: The bash loop code with explanation
- [ ] CLI demo: Show the actual bash command

**Production Steps:**
```bash
# 1. Generate SVG with the loop
claude --print "Generate SVG (1920x1080, dark bg #0a0512): Center shows code block with 'while :; do cat PROMPT.md | claude-code ; done' in monospace green text. Around it: arrows showing loop cycle. Labels: 'Prompt stays same', 'Files persist', 'Git tracks progress'. Ralph Wiggum silhouette icon in corner" > work/svg/03-technique.svg

# 2. Generate TTS
vid-tts --text "The Ralph Wiggum technique flips this..." --output work/audio/03-technique.wav

# 3. Create diagram video
vid-image --input work/svg/03-technique.svg --duration 22 --output work/clips/03-technique.mp4

# 4. Mix audio
ffmpeg -i work/clips/03-technique.mp4 -i work/audio/03-technique.wav -c:v copy -c:a aac work/clips/03-technique-final.mp4
```

---

### Segment 04: The Official Plugin (CLI Demo)
**Duration:** 25s
**Narration:** "Anthropic formalized this into an official Claude Code plugin. Use slash ralph loop with your prompt, set max iterations as a safety net, and define a completion promise. Claude will loop until it outputs that promise or hits the limit. You can cancel anytime with slash cancel ralph."

**Assets:**
- [ ] VHS recording: Real Claude Code showing /ralph-loop command

**VHS Tape:**
```tape
Output 04-plugin.mp4
Set FontSize 20
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 35ms

Type "claude"
Enter
Sleep 5s
Type "/help ralph"
Enter
Sleep 8s
Type "/ralph-loop \"Add unit tests for card_list.rs until coverage > 80%. Output <promise>TESTS_COMPLETE</promise> when done.\" --max-iterations 10 --completion-promise TESTS_COMPLETE"
Sleep 3s
Ctrl+C
Sleep 2s
Type "/exit"
Enter
Sleep 1s
```

**Production Steps:**
```bash
# 1. Create VHS tape file
cat > work/vhs/04-plugin.tape << 'EOF'
[tape content above]
EOF

# 2. Record with VHS
cd work/vhs && vhs 04-plugin.tape && mv 04-plugin.mp4 ../clips/

# 3. Generate TTS
vid-tts --text "Anthropic formalized this..." --output work/audio/04-plugin.wav

# 4. Mix audio (or use as voiceover)
```

---

### Segment 05: Meet Our Demo Project (Web + CLI)
**Duration:** 30s
**Narration:** "Let me show you a real example. This is Rolodex. A three D contact management app built with Rust and WebAssembly. It has thirteen passing tests. But the CardList component has zero tests. That is one hundred lines of untested code. Our ralph task. Add comprehensive tests until we have full coverage."

**Assets:**
- [ ] MCP Playwright: GitHub repo screenshots
- [ ] MCP Playwright: Live app demo (if deployed)
- [ ] CLI: Show current test count

**Playwright Actions:**
```json
[
  {"action": "navigate", "url": "https://github.com/softwarewrighter/test-ralph"},
  {"action": "wait", "ms": 2000},
  {"action": "screenshot", "name": "05-github-repo"},
  {"action": "click", "selector": "a[title='src']"},
  {"action": "wait", "ms": 1500},
  {"action": "screenshot", "name": "05-src-folder"},
  {"action": "click", "selector": "a[title='components']"},
  {"action": "wait", "ms": 1500},
  {"action": "screenshot", "name": "05-components"},
  {"action": "click", "selector": "a[title='card_list.rs']"},
  {"action": "wait", "ms": 1500},
  {"action": "screenshot", "name": "05-card-list-code"}
]
```

**VHS Tape (test count):**
```tape
Output 05-test-count.mp4
Set FontSize 20
Set Width 1920
Set Height 1080
Set Theme "Dracula"

Type "cd ~/github/softwarewrighter/test-ralph"
Enter
Sleep 1s
Type "wasm-pack test --headless --chrome 2>&1 | tail -5"
Enter
Sleep 10s
Type "grep -c '#\[wasm_bindgen_test\]' src/components/card_list.rs"
Enter
Sleep 2s
Type "# Zero tests in card_list.rs!"
Enter
Sleep 2s
```

**Production Steps:**
```bash
# 1. Capture GitHub with Playwright (via Claude MCP tools)
# Screenshots saved to work/web/05-github/

# 2. Record test count with VHS
cd work/vhs && vhs 05-test-count.tape && mv 05-test-count.mp4 ../clips/

# 3. Convert screenshots to video with Ken Burns
ffmpeg -framerate 0.3 -pattern_type glob -i 'work/web/05-github/*.png' \
  -vf "scale=1920:1080,zoompan=z='min(zoom+0.001,1.15)':d=90:s=1920x1080" \
  -c:v libx264 -pix_fmt yuv420p work/clips/05-github.mp4

# 4. Concatenate GitHub + test count clips
vid-concat work/clips/05-github.mp4 work/clips/05-test-count.mp4 --output work/clips/05-demo-project.mp4

# 5. Generate and mix TTS
vid-tts --text "Let me show you a real example..." --output work/audio/05-demo.wav
```

---

### Segment 06: The PROMPT.md (CLI)
**Duration:** 20s
**Narration:** "First we write our prompt. It defines the task clearly. Add tests for CardList component. It specifies completion criteria. All edge cases covered and tests passing. And it includes the magic completion promise. Tests complete in angle brackets."

**Assets:**
- [ ] VHS: Create and show PROMPT.md content

**VHS Tape:**
```tape
Output 06-prompt.mp4
Set FontSize 18
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 25ms

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
Type "5. Test selection highlighting"
Enter
Type "6. All tests must pass"
Enter
Enter
Type "## Completion Criteria"
Enter
Type "When all tests pass and coverage is complete, output:"
Enter
Type "<promise>TESTS_COMPLETE</promise>"
Enter
Type "EOF"
Enter
Sleep 2s
Type "cat PROMPT.md"
Enter
Sleep 5s
```

---

### Segment 07: Ralph In Action - Iteration 1 (CLI)
**Duration:** 45s
**Narration:** "Now we start the ralph loop. Watch iteration one. Claude reads the prompt. Analyzes the CardList component. Writes the first test. A simple props validation. The test runs. It passes. But we are not done. Claude knows it needs more tests. So it continues."

**Assets:**
- [ ] VHS: Real /ralph-loop execution, first iteration

**VHS Tape:**
```tape
Output 07-iteration-1.mp4
Set FontSize 16
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 30ms

Type "cd ~/github/softwarewrighter/test-ralph"
Enter
Sleep 1s
Type "claude --dangerously-skip-permissions"
Enter
Sleep 5s
Type "/ralph-loop \"$(cat PROMPT.md)\" --max-iterations 10 --completion-promise TESTS_COMPLETE"
Enter
Sleep 45s
```

**Note:** This captures real iteration. May need to record longer and trim.

---

### Segment 08: Iterations 2-4 (CLI Montage)
**Duration:** 40s
**Narration:** "Iteration two adds the empty state test. Iteration three tests card rendering. Iteration four tackles the callbacks. Each iteration, Claude reads its previous work, sees what is missing, and adds the next piece. The test count grows. One. Two. Three. Four."

**Assets:**
- [ ] VHS continuation or separate recordings
- [ ] Test count overlay showing progress

**Production Notes:**
- May need to record full ralph session and extract key moments
- Consider time-lapse effect for middle iterations
- Show test output after each iteration

---

### Segment 09: The Completion (CLI)
**Duration:** 20s
**Narration:** "Finally, iteration five. Claude adds the selection test. Runs all tests. Six passing. Coverage complete. And there it is. The completion promise. Tests complete. The loop stops. Task done."

**Assets:**
- [ ] VHS: Final iteration showing TESTS_COMPLETE output

---

### Segment 10: Results Summary (Diagram)
**Duration:** 15s
**Narration:** "In five iterations, zero to six tests. One hundred percent coverage for CardList. No manual intervention. The prompt defined the goal. Ralph handled the iteration. This is the power of writing prompts that converge."

**Assets:**
- [ ] SVG: Before/after comparison, test count graph

**Production Steps:**
```bash
claude --print "Generate SVG (1920x1080, dark bg): Left side 'Before' box showing 0 tests, red. Right side 'After' box showing 6 tests, green. Center shows arrow with '5 iterations'. Bottom bar chart showing test growth 0→1→2→3→4→6. Title: 'Zero to Full Coverage'" > work/svg/10-results.svg
```

---

### Segment 11: Best Practices (Diagram)
**Duration:** 20s
**Narration:** "Writing good ralph prompts is an art. First, clear completion criteria. What does done look like. Second, break complex tasks into phases. Third, include self correction. Tell Claude to run tests and fix failures. Fourth, always set max iterations. It is your safety net. And remember. Failures are data for tuning your prompt."

**Assets:**
- [ ] SVG: Four best practices boxes with icons

---

### Segment 12: Real World Results (Diagram)
**Duration:** 15s
**Narration:** "The results in the wild are remarkable. Geoffrey Huntley built Cursed Lang, an entire programming language, over three months using ralph. Y Combinator hackathon teams shipped six production repos overnight. One developer completed a fifty thousand dollar contract for under three hundred dollars in A P I costs."

**Assets:**
- [ ] SVG: Three result cards with stats

---

### Segment 13: CTA (Avatar)
**Duration:** 12s
**Narration:** "The ralph wiggum plugin is built into Claude Code. Try slash ralph loop on your next project. Start small. Define clear criteria. Trust the loop. Let me know how it works for you."

**Assets:**
- [ ] SVG background: /ralph-loop command, tips
- [ ] Avatar lipsync

---

## Production Schedule

### Phase 1: SVG Generation
Generate all diagram SVGs:
- 01-hook-bg.svg
- 02-problem.svg
- 03-technique.svg
- 10-results.svg
- 11-best-practices.svg
- 12-real-results.svg
- 13-cta-bg.svg

### Phase 2: Web Captures (MCP Playwright)
- GitHub repo tour (segment 05)
- Live app demo if available

### Phase 3: CLI Recording (VHS)
1. 04-plugin.tape - Show /ralph-loop command
2. 05-test-count.tape - Current test state
3. 06-prompt.tape - Create PROMPT.md
4. 07-09-ralph-session.tape - Full ralph execution (may be one long recording, then split)

### Phase 4: TTS Generation
Generate all narration audio files.

### Phase 5: Avatar Lipsync
- 01-hook avatar
- 13-cta avatar

### Phase 6: Assembly
1. Normalize all clips (1920x1080, 30fps, 44100Hz stereo)
2. Mix audio with video
3. Concatenate all segments
4. Add title card and end card
5. Final export

---

## File Structure

```
projects/ralph-wiggum/work/
├── svg/
│   ├── 01-hook-bg.svg
│   ├── 02-problem.svg
│   ├── 03-technique.svg
│   ├── 10-results.svg
│   ├── 11-best-practices.svg
│   ├── 12-real-results.svg
│   └── 13-cta-bg.svg
├── vhs/
│   ├── 04-plugin.tape
│   ├── 05-test-count.tape
│   ├── 06-prompt.tape
│   └── 07-ralph-session.tape
├── web/
│   └── 05-github/
│       ├── 01-repo.png
│       ├── 02-src.png
│       ├── 03-components.png
│       └── 04-card-list.png
├── audio/
│   ├── 01-hook.wav
│   ├── 02-problem.wav
│   └── ... (all segments)
├── clips/
│   ├── 01-hook.mp4
│   ├── 02-problem.mp4
│   └── ... (all segments)
└── final/
    └── ralph-wiggum-explainer.mp4
```

---

## Total Estimated Duration
- Segments 01-13: ~250 seconds (~4 minutes)
- With transitions: ~4:30

## Key Risks

1. **Ralph session unpredictability** - Real claude output varies. May need multiple takes.
2. **VHS recording length** - Full ralph session could be 10+ minutes. Will need to speed up or montage.
3. **Test-ralph repo state** - Need clean git state before recording.

## Mitigation

1. **Pre-run ralph** offline to understand iteration count and timing
2. **Record full session** then edit down to key moments
3. **Create git branch** for demo, reset between takes
