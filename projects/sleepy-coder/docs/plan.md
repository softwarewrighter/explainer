# Sleepy Coder Explainer Video Plan

## Project Status: IN-PROGRESS

The underlying sleepy-coder implementation has Phase 1 MVP complete (72 tests). No validated results yet - the overnight learning cycle has not been run with real metrics.

## Video Concept

"How to Build a Coding AI That Learns from Its Mistakes"

Explainer video (~5-10 min) demonstrating:
1. The problem: AI coding agents repeat the same errors
2. The solution: Parameter-efficient continual learning (PaCT)
3. The "sleep learning" metaphor: capture mistakes by day, train overnight
4. Demo: showing measurable improvement over sleep cycles

## Source Materials

### From Main Repo (~/github/softwarewrighter/sleepy-coder)
- docs/research.txt - Full ChatGPT research conversation
- docs/architecture.md - System design
- docs/design.md - Technical details
- docs/plan.md - Implementation phases
- docs/status.md - Current progress (Phase 1 MVP complete)
- rust/ - Rust implementation (agent, eval, sandbox, koans)
- py/ - Python training pipeline (to be implemented)

### From Shorts Project (../shorts/projects/sleepy-coder)
- work/narration.txt - 2-minute narration script
- work/slides-outline.txt - Visual theme and slide concepts
- showcase/slides/ - HTML slide templates (00-hook through 06-cta)
- work/description.txt - YouTube description

## Potential Demo Approaches

### Option A: VHS Terminal Recording
- Show the agent loop running: RED → patch → GREEN
- Capture compiler errors and fixes
- Show eval metrics improving

### Option B: Playwright Screen Capture
- Capture web UI if sleepy-coder has one (check rust/wasm or py/web)
- Show plots/charts of learning progress
- Interactive demo of the eval dashboard

### Option C: Plot Animation
- Pre-render matplotlib plots showing:
  - Repeat error rate vs sleep cycles
  - Steps-to-green over time
  - Regression test stability
- Animate the lines growing with each cycle

## Video Structure (Draft)

| Segment | Content | Type | Duration |
|---------|---------|------|----------|
| 00-title | Sleepy Coder title card | Image + music | 5s |
| 01-hook | "What if AI could learn from mistakes?" | SVG + narration | 20s |
| 02-problem | The memory problem - repeated errors | SVG + narration | 25s |
| 03-solution | Sleep learning concept | SVG + narration | 30s |
| 04-architecture | Three phases: Day/Sleep/Eval | SVG + narration | 30s |
| 05-demo-cli | Agent loop running (VHS or Playwright) | Demo + narration | 60s |
| 06-demo-results | Plots showing improvement | Charts + narration | 45s |
| 07-efficient | LoRA in shared subspace | SVG + narration | 25s |
| 08-summary | What we showed | SVG + narration | 20s |
| 99-cta | Try it yourself, GitHub link | SVG + narration | 15s |
| 99b-epilog | Shared epilog | Video | 13s |
| 99c-epilog-ext | Music fade | Image + music | 10s |

## Technical Requirements

### Demos to Capture
1. **Agent loop** - needs Ollama running with a small model (e.g., qwen2.5-coder:1.5b)
2. **Rust koans** - 42 builtin koans across 5 error families
3. **Eval metrics** - needs matplotlib plots from py/sleepy_pact/viz/

### Pre-requisites
- [ ] Run the agent loop once to generate sample episodes
- [ ] Run eval to generate baseline metrics
- [ ] Generate improvement plots (even synthetic for demo)

## Paper References

- [Share LoRA Subspaces](https://arxiv.org/html/2602.06043v1) - PaCT approach
- [Universal Weight Subspace Hypothesis](https://arxiv.org/abs/2512.05117) - Basis reuse
- O-LoRA, KeepLoRA, SPARC, C-LoRA - Related methods

## Next Steps

1. Verify sleepy-coder can run locally (Ollama + qwen2.5-coder)
2. Generate sample episode data
3. Create synthetic "improvement over time" plots
4. Write narration scripts for each segment
5. Design SVG slides following style guide
6. Record demos (VHS for CLI, Playwright for any web UI)
7. Assemble video segments
