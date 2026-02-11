# Sleepy Coder: Towards Continuous LLM Learning (Part 1)

## Video Concept

An optimistic explainer (~4-5 min) introducing our vision for continuous LLM learning, the Share algorithm approach, key insights discovered, and the path forward. Part 1 of a series. Focus on progress and future potential.

## Story Arc (Optimistic Framing)

1. **The Vision** - AI that learns from mistakes while you sleep
2. **The Challenge** - Teaching without forgetting (catastrophic forgetting)
3. **The Discovery** - Share algorithm from Johns Hopkins research
4. **The System** - Sleepy Coder's day/night learning cycle
5. **The Results** - 76.7% accuracy, Share prevents forgetting
6. **The Insight** - Don't average adapters, route to specialists
7. **Next Steps** - Task routing, larger models (Part 2 preview)

---

## Video Structure

| # | Segment | Content | Type | Duration |
|---|---------|---------|------|----------|
| 00 | title | Title card with music | Image + music | 5s |
| 01 | hook | The vision: AI that learns overnight | SVG + narration | ~15s |
| 02 | challenge | Catastrophic forgetting problem | SVG + narration | ~18s |
| 03 | discovery | Share algorithm from research | SVG + narration | ~18s |
| 04 | system | Day/night learning cycle | SVG + narration | ~20s |
| 05 | results | 76.7% with task-specific adapters | SVG + narration | ~18s |
| 06 | insight | The averaging trap, routing solution | SVG + narration | ~20s |
| 07 | next-steps | Part 2 preview, future work | SVG + narration | ~18s |
| 99 | cta | Try it yourself, links | SVG + narration | ~15s |
| 99b | epilog | Shared epilog | Video | ~13s |
| 99c | epilog-ext | Music fade | Image + music | 10s |

**Estimated total: ~3-4 minutes**

---

## Narration Scripts (TTS-compliant)

All scripts: max 320 chars, periods/commas only, no digits, spell out numbers.

### 01-hook.txt
What if your coding assistant could learn from its mistakes while you sleep. Wake up to a smarter model. No manual retraining. This is our vision for continuous learning.

### 02-challenge.txt
The challenge is catastrophic forgetting. When you train a model on new patterns, it forgets what it already knew. Fix one bug, break three others. We needed a better approach.

### 03-discovery.txt
We found the Share algorithm in recent research from Johns Hopkins. It extracts a shared subspace using S V D. New tasks train only tiny coefficient vectors. Sixty seven times fewer parameters.

### 04-system.txt
Sleepy Coder runs a day night cycle. During the day, the agent fixes Rust compiler errors. Failed attempts get captured. At night, we train new adapters and consolidate knowledge. Then evaluate.

### 05-results.txt
The results are promising. Task specific coefficients achieved seventy six point seven percent accuracy. The Share algorithm successfully prevents forgetting. We can add skills without breaking old ones.

### 06-insight.txt
The key insight, routing beats averaging. When we averaged coefficients across tasks, gains disappeared. Specialists outperform generalists. Route each error to the right adapter.

### 07-next-steps.txt
Part two will implement task routing. Detect the error type, select the matching adapter. We will also test larger models with more capacity. The foundation is solid, now we scale.

### 99-cta.txt
The code is open source on Git Hub. Try it on your own Rust projects. Links to the repo and research papers are in the description. Part two coming soon.

---

## SVG Slide Designs

### 01-hook.svg
- Headline: "Learn While You Sleep" (cyan)
- Subtitle: "Continuous Learning for LLMs" (white)
- Visual: Moon icon or sleeping metaphor
- Avatar zone clear (bottom-right)

### 02-challenge.svg
- Headline: "The Forgetting Problem" (red)
- Subtitle: "Catastrophic Forgetting" (white)
- Two boxes: "Learn New" (green) vs "Forget Old" (red)
- Arrow showing knowledge loss

### 03-discovery.svg
- Headline: "The Share Algorithm" (green)
- Subtitle: "Johns Hopkins Research" (white)
- Three-phase boxes:
  - Phase 1: Extract basis (SVD)
  - Phase 2: Train coefficients
  - Phase 3: Consolidate

### 04-system.svg
- Headline: "Day/Night Cycle" (yellow)
- Subtitle: "Sleepy Coder Architecture" (white)
- Circular flow: DAY → CAPTURE → SLEEP → TRAIN → EVAL → DEPLOY

### 05-results.svg
- Headline: "What We Achieved" (green)
- Subtitle: "Share in Practice" (white)
- Three result boxes:
  - 76.7% accuracy (green)
  - Zero regressions (green)
  - 51 adapters trained (yellow)

### 06-insight.svg
- Headline: "Route, Don't Blend" (cyan)
- Subtitle: "The Key Insight" (white)
- Two columns:
  - LEFT (red): Average → 73.3%
  - RIGHT (green): Route → 76.7%

### 07-next-steps.svg
- Headline: "Coming in Part 2" (yellow)
- Subtitle: "The Road Ahead" (white)
- Three boxes: Task Routing, Larger Models, VS Code Extension

### 99-cta.svg
- Headline: "Try It Yourself" (green)
- Two boxes:
  - GitHub: sleepy-coder repo
  - Papers: Share, UWSH on arXiv
- Footer: Part 2 coming soon

---

## Asset Checklist

### Done
- [x] 00-title.mp4 (shared-spaces background, "In or Out" music)

### SVGs to Create
- [ ] 01-hook.svg
- [ ] 02-challenge.svg
- [ ] 03-discovery.svg
- [ ] 04-system.svg
- [ ] 05-results.svg
- [ ] 06-insight.svg
- [ ] 07-next-steps.svg
- [ ] 99-cta.svg

### TTS to Generate
- [ ] 01-hook.wav through 99-cta.wav (8 files)

### Epilog
- [ ] 99b-epilog.mp4 (copy from reference)
- [ ] 99c-epilog-ext.mp4 (create with "In or Out" music fade)

---

## Research References

### Johns Hopkins University Team
- Prakhar Kaushik, Ankit Vaidya, Shravan Chaudhari, Rama Chellappa, Alan Yuille

### Papers
1. **Share**: "Shared LoRA Subspaces for Almost Strict Continual Learning" (arXiv:2602.06043)
2. **UWSH**: "The Universal Weight Subspace Hypothesis" (arXiv:2512.05117)

---

## Music
- Title + Epilog Extension: "In or Out" by Telecasted
