# Ralph Wiggum Technique Explainer Video

## Overview
Explain the Ralph Wiggum technique with a **real demonstration** using the test-ralph (Rolodex 3D) project.

## Demo Project
- **Repo:** ~/github/softwarewrighter/test-ralph
- **Type:** Rust/WASM 3D contact manager (Rolodex)
- **Current state:** 13 tests, CardList component has 0 tests
- **Demo task:** Add unit tests for CardList (0 → 6+ tests)

## Why This Task
- Not trivial: requires multiple tests across different aspects
- Not impossible: CardList is 101 lines, well-defined functionality
- Visible progress: test count increases each iteration
- Educational: shows test-driven development in action
- Estimated iterations: 4-7

## Asset Capture Tools

| Asset Type | Tool | Usage |
|------------|------|-------|
| CLI recordings | VHS | Record real Claude Code + ralph plugin |
| Web captures | MCP Playwright | GitHub repo tour, live app demo |
| Diagrams | Claude SVG | Problem/solution visuals |
| Avatar | TTS + Lipsync | Hook and CTA segments |

## Video Structure (14 segments, ~4-5 min)

### Opening (45s)
1. **01-hook** (avatar) - "$50K contract for $297"
2. **02-problem** (diagram) - Manual iteration tedium
3. **03-technique** (diagram) - The while loop core

### The Plugin (25s)
4. **04-plugin** (cli) - Show /ralph-loop command in Claude

### Real Demo (100s)
5. **05-demo-github** (web) - GitHub repo tour via Playwright
6. **06-test-count** (cli) - Show current 0 tests in CardList
7. **07-prompt** (cli) - Create PROMPT.md live
8. **08-ralph-start** (cli) - Start ralph loop, iteration 1
9. **09-iterations-montage** (diagram) - Iterations 2-5 summary
10. **10-completion** (cli) - Final iteration + completion promise

### Wrap-up (62s)
11. **11-results** (diagram) - Before/after comparison
12. **12-best-practices** (diagram) - Four tips for prompts
13. **13-real-results** (diagram) - $50K, 6 repos, Cursed Lang
14. **14-cta** (avatar) - Try it yourself

## Production Phases

### Phase 1: SVG Generation
- [ ] 01-hook-bg.svg - "$50K → $297" glow
- [ ] 02-problem.svg - Ping-pong iteration diagram
- [ ] 03-technique.svg - While loop code block
- [ ] 09-iterations-montage.svg - Progress timeline
- [ ] 11-results.svg - Before/after comparison
- [ ] 12-best-practices.svg - Four tips grid
- [ ] 13-real-results.svg - Three result cards
- [ ] 14-cta-bg.svg - Command + tips

### Phase 2: Web Captures (MCP Playwright)
- [ ] GitHub repo main page
- [ ] src/ folder
- [ ] components/ folder
- [ ] card_list.rs file view

### Phase 3: CLI Recording (VHS)
- [ ] 04-plugin.tape - /ralph-loop help
- [ ] 06-test-count.tape - Show 0 tests
- [ ] 07-prompt.tape - Create PROMPT.md
- [ ] 08-ralph-session.tape - Full ralph execution

### Phase 4: TTS + Avatar
- [ ] Generate all narration .wav files
- [ ] Lipsync segments 01, 14

### Phase 5: Assembly
- [ ] Normalize all clips
- [ ] Mix audio
- [ ] Concatenate
- [ ] Final export

## Key Files
- `docs/production-plan.md` - Detailed step-by-step production guide
- `work/script.json` - Full segment definitions
- `work/vhs/` - VHS tape files
- `work/svg/` - Generated diagrams
- `work/web/` - Playwright screenshots
- `work/clips/` - Final segment videos
- `work/audio/` - TTS narration files

## Notes
- Pre-run ralph offline to understand timing and iteration count
- Create git branch in test-ralph for demo, reset between takes
- Full ralph session may be 10+ minutes - speed up or montage middle iterations
- Real Claude output varies - may need multiple takes
