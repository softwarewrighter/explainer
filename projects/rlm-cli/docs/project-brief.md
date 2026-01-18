# RLM CLI Explainer Video

## Overview
RLM CLI demonstrates Level 3 (L3) native execution - running Rust CLI tools directly without sandboxing. This is the final level of the RLM execution hierarchy.

## Subject
The ../rlm-project L3 demos:
- L3 demo scripts showing native CLI execution
- Visualizer demos (to be recorded via OBS)

## Video Focus
- Native Rust CLI execution (no WASM sandbox)
- Performance benefits of native code
- Visualizer tool demonstrations
- When to use L3 vs L1/L2

## Key Messages
- L3 is for trusted, performance-critical code
- Native execution removes sandbox overhead
- Visualizer shows RLM execution flow
- Complete the L1 → L2 → L3 progression

## Assets Needed
- [ ] Title image (user will add)
- [ ] L3 architecture diagram
- [ ] Demo recordings (OBS for visualizer)
- [ ] Comparison chart (L1 vs L2 vs L3)

## Duration Target
~3:30 (similar to other explainer videos)

## SVG Design Requirements

All SVG slides must follow the font size guidelines in `/docs/svg-design-guidelines.md`.

### Minimum Font Sizes
- **All text: 28px minimum** (never smaller)
- Body text: 28-32px
- Monospace/URLs: 28-32px
- Headlines: 84-96px
- Stroke widths: 4-5px for visibility

## Recording Notes

### VHS Recordings (terminal demos)
- L3 script execution demos
- Can be automated with VHS tape files
- **Environment variables**: Use this pattern to load env vars in VHS:
  ```
  Type "export $(cat ~/.env | grep -v '^#' | xargs) && ./your-script.sh"
  ```
  This reliably exports variables from `~/.env` (e.g., `LITELLM_MASTER_KEY`) for LiteLLM API access.
  Note: `source ~/.env` does not work reliably in VHS recordings.

### OBS Recordings (visualizer)
- Visualizer requires OBS for GUI capture
- Record at 1920x1080, 30fps
- Trim and process with ffmpeg
