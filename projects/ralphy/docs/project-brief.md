# Ralphy Explainer Video

## Overview
Ralphy is a parallel orchestration tool for video publishing tasks. This video demonstrates how Ralphy can divide and parallelize the video production pipeline.

## Series Context
This is video 3 of a 4-part RLM series:
1. RLM Introduction (L1 DSL)
2. RLM WASM: Custom Code in a Sandbox (L2 WebAssembly) - DONE
3. **Ralphy: Parallel Video Publishing** - THIS VIDEO
4. RLM Rust CLI (L3 Native Execution)

## Video Focus
- Benefits of parallel task orchestration
- How Ralphy divides video publishing tasks
- Demo of Ralphy in action on the next RLM video pipeline

## Key Messages
- Video publishing has many parallelizable tasks
- Ralphy coordinates these tasks efficiently
- Sets up the next video (RLM Rust CLI)

## Assets Needed
- [ ] Title image (user will add)
- [ ] Ralphy architecture diagram
- [ ] Task dependency visualization
- [ ] Demo recordings of Ralphy running

## Duration Target
~3:30 (208 seconds)

## SVG Design Requirements

All SVG slides must follow the font size guidelines in `/docs/svg-design-guidelines.md`.

### Minimum Font Sizes
- **All text: 28px minimum** (never smaller)
- Body text: 28-32px
- Monospace/URLs: 28-32px
- Headlines: 84-96px
- Stroke widths: 4-5px for visibility

### Example
```svg
<!-- Correct -->
<text font-size="28" fill="#50fa7b">github.com/michaelshimeles/ralphy</text>
<text font-size="32" fill="#8be9fd">Demo Examples</text>
<rect stroke-width="5" ... />

<!-- Wrong - too small -->
<text font-size="22" fill="#8be9fd">Label</text>
<text font-size="24" fill="#50fa7b">github.com/repo</text>
```
