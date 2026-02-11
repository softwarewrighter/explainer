# Engram Revisited: From Emulation to Implementation

## Video Concept

A "lessons learned" explainer (~8-10 min) documenting the journey from behavioral emulation to real Engram implementation, the pitfalls encountered, and key insights about when hash-based memory helps (and when it doesn't).

## The Story Arc

1. **The Starting Point** - LoRA fine-tuning to make models "behave" like they have memory
2. **The Discovery** - weagan/Engram implements real hash-based memory in ~300 lines
3. **The Port** - Integrating EnhancedEngramModule with HuggingFace models
4. **The Reality Check** - Hash-based memory isn't magic; it has specific strengths
5. **The Key Insight** - Engram excels at exact-match lookups, not pattern generalization
6. **The Path Forward** - Where Engram fits in the AI toolkit

## Source Materials

### From engram-poc Repo
- docs/comparison-weagan.md - Implements vs Emulates comparison
- docs/engram-memory-integration.md - Integration results
- docs/proposed-work.md - Findings, experiments, recommendations
- docs/explanation.md - ELI5 guide
- images/engram_demo_results.png - **4-panel proof of O(1) memory**
- images/plots/cuda-accuracy-comparison.png - **CUDA accuracy chart**
- results/combined_eval_results.png - **Baseline vs Engram comparison**
- results/exact_match_eval.json - Category breakdown

### Key Plots for Video Segments
| Image | Content | Use In Segment |
|-------|---------|----------------|
| engram_demo_results.png | 4-panel: training accuracy, long-term recall, loss, improvement | 05-real-engram |
| cuda-accuracy-comparison.png | 8.59% → 14.06% (+63.6%) | 03-emulation-results |
| combined_eval_results.png | Baseline vs Engram accuracy/latency | 06-reality-check |

---

## Video Structure

| # | Segment | Content | Type | Duration |
|---|---------|---------|------|----------|
| 00 | title | Engram Revisited title card | Image + music | 5s |
| 01 | hook | "We tried to emulate memory, then found a better way" | SVG + narration | 20s |
| 02 | problem | The pattern completion problem | SVG + narration | 25s |
| 03 | emulation | LoRA fine-tuning approach (behavioral) | SVG + narration | 25s |
| 04 | discovery | weagan/Engram - real hash-based memory | SVG + narration | 25s |
| 05 | real-engram | How EnhancedEngramModule works | SVG + narration | 30s |
| 06 | demo-synthetic | Plot: O(1) memory proof (4-panel image) | Image + narration | 35s |
| 07 | integration | Porting to HuggingFace/SmolLM | SVG + narration | 25s |
| 08 | reality-check | Hash-based memory limitations | SVG + narration | 30s |
| 09 | demo-results | Plot: Exact-match evaluation results | Image + narration | 30s |
| 10 | key-insight | When Engram works vs when it doesn't | SVG + narration | 30s |
| 11 | summary | What we learned | SVG + narration | 25s |
| 99 | cta | Try it yourself, GitHub links | SVG + narration | 20s |
| 99b | epilog | Shared epilog | Video | 13s |
| 99c | epilog-ext | Music fade | Image + music | 10s |

**Total estimated duration: ~6-7 minutes**

---

## Detailed Segment Plans

### 01-hook.svg
**Headline:** "From Emulation to Implementation"
**Subtitle:** "A Journey Through Engram Memory"
**Content:** Two-box layout:
- Box 1 (yellow): "Emulation" - LoRA fine-tuning to mimic memory behavior
- Box 2 (green): "Implementation" - Real O(1) hash-based memory module

**01-hook.txt:**
"We started by training models to act like they had memory. But then we found an open source implementation that does it for real. This is what we learned along the way."

### 02-problem.svg
**Headline:** "The Pattern Problem"
**Subtitle:** "LLMs Recompute Everything"
**Content:** Single box showing:
- Input: "for i in range(" → Expensive attention computation
- The same pattern computed fresh every time
- Engram's promise: O(1) lookup for common patterns

**02-problem.txt:**
"Language models recompute everything from scratch. Even common patterns like for loops get full attention treatment every time. Engram promises to fix this with direct memory lookup."

### 03-emulation.svg
**Headline:** "Attempt One: Emulation"
**Subtitle:** "LoRA Fine-Tuning"
**Content:** Architecture diagram:
- Base Model (frozen) + LoRA Adapters
- Train on patterns → behaves like it has memory
- Result: 8.6% → 14% accuracy (+63% relative)

**03-emulation.txt:**
"Our first approach used LoRA fine tuning. We trained a small model on hundreds of patterns until it behaved like it had memory. Accuracy improved sixty three percent, but the architecture stayed the same."

### 04-discovery.svg
**Headline:** "The Discovery"
**Subtitle:** "weagan/Engram on GitHub"
**Content:**
- Reference: github.com/weagan/Engram
- "Real Engram in ~300 lines of Python"
- Key components: Hash table, Multi-head hashing, Gated injection

**04-discovery.txt:**
"Then we found weagan's Engram repo on GitHub. It implements real hash based memory in about three hundred lines. A learnable memory table, deterministic hashing, and a gate that decides when to trust the lookup."

### 05-real-engram.svg
**Headline:** "How It Works"
**Subtitle:** "O(1) Hash-Based Memory"
**Content:** Flow diagram:
1. Input tokens → Multi-head hash → Memory indices
2. O(1) lookup from memory table (50K slots)
3. Gate decides: trust memory or ignore?
4. Residual connection back to hidden states

**05-real-engram.txt:**
"The Enhanced Engram Module hashes each token to memory slots using multiple hash functions. The lookup is O one, constant time regardless of sequence length. A learned gate decides how much to trust each retrieval."

### 06-demo-synthetic (IMAGE SEGMENT)
**Source:** images/engram_demo_results.png
**Narration:** Describe the 4 panels

**06-demo-synthetic.txt:**
"The proof is in the plots. Top left shows Engram reaching perfect accuracy by epoch two while baseline is still climbing. Top right shows perfect long term recall even with four hundred tokens of distraction. Bottom left shows loss convergence. Bottom right shows consistent improvement across all sequence lengths."

### 07-integration.svg
**Headline:** "Integration"
**Subtitle:** "SmolLM + EnhancedEngramModule"
**Content:**
- Wrapper injects Engram after each transformer layer
- Base model frozen, only memory trained
- 50K memory slots, 67M additional parameters

**07-integration.txt:**
"We ported the module to work with Hugging Face models. A wrapper injects Engram after each transformer layer. The base model stays frozen while only the memory table and gates get trained."

### 08-reality-check.svg
**Headline:** "Reality Check"
**Subtitle:** "Not Everything Works"
**Content:** Two-column comparison:
- Works: Exact lookups, Structured keys, Long-term recall
- Fails: Pattern completion, Random mappings, Semantic similarity

**08-reality-check.txt:**
"But hash based memory is not magic. It excels at exact match lookups with structured keys. It struggles with pattern completion that needs generalization. Same input must always need same output."

### 09-demo-results (IMAGE SEGMENT)
**Source:** Create composite or use exact_match_eval.json data
**Narration:** Category breakdown

**09-demo-results.txt:**
"The exact match evaluation tells the story. Engram jumped to seventy five percent on acronym expansion, sixty seven percent on element names. But it actually hurt performance on capitals where the base model already knew the answers."

### 10-key-insight.svg
**Headline:** "The Key Insight"
**Subtitle:** "A Specialized Tool"
**Content:** Two-column table:
- Use Engram: FAQ responses, Terminology, Entity facts, Code boilerplate
- Don't Use: Creative tasks, Novel combinations, Context-dependent answers

**10-key-insight.txt:**
"Engram is a specialized tool, not a general enhancement. Use it for consistent lookups, terminology expansion, entity facts. Skip it for creative tasks or anything that needs generalization from context."

### 11-summary.svg
**Headline:** "What We Learned"
**Subtitle:** "The Journey"
**Content:** Three boxes:
1. (yellow) Emulation → Behavioral approximation works but doesn't scale
2. (green) Implementation → Real O(1) memory is simple to build
3. (cyan) Application → Match the task to the tool's strengths

**11-summary.txt:**
"Three lessons from this journey. First, behavioral emulation through LoRA works but has limits. Second, real Engram memory is simpler than expected. Third, the tool must match the task. Hash based memory is for recall, not reasoning."

### 99-cta.svg
**Headline:** "Try It Yourself"
**Content:**
- Box 1 (green): engram-poc repo with full implementation
- Box 2 (red): weagan/Engram reference implementation
- Box 3 (yellow): DeepSeek Engram paper

**99-cta.txt:**
"The code is open source. Engram P O C has the full integration with Hugging Face models. Weagan's repo has the clean reference implementation. Links to both and the Deep Seek paper are in the description."

---

## Demo Recording Plan

### VHS Tape Recordings (I can generate)
| Tape | Content | Commands |
|------|---------|----------|
| 01-lora-training.tape | LoRA fine-tuning output | `./scripts/train.sh` |
| 02-demo-comparison.tape | Before/after model outputs | `./scripts/demo.sh` |
| 03-engram-test.tape | Engram module unit tests | `python -m src.memory.test_engram` |

### OBS Recordings (You record)
| Recording | Content | What to Capture |
|-----------|---------|-----------------|
| 01-weagan-repo | GitHub page tour | Browse weagan/Engram, show notebook |
| 02-code-walkthrough | EnhancedEngramModule code | Scroll through engram_module.py |

### Plot Images (Already exist)
| Image | Segment | Notes |
|-------|---------|-------|
| engram_demo_results.png | 06-demo-synthetic | 4-panel proof plot |
| cuda-accuracy-comparison.png | 03-emulation (optional) | Accuracy bar chart |
| combined_eval_results.png | 08-reality-check (optional) | Comparison bars |

---

## References

- [engram-poc](https://github.com/softwarewrighter/engram-poc) - This implementation
- [weagan/Engram](https://github.com/weagan/Engram) - Reference implementation
- [DeepSeek Engram Paper](https://arxiv.org/abs/2601.07372) - Original research

---

## Files Needed from User

1. **Title card image** (00-title) - Can reuse engram-poc thumbnail or create new
2. **Background music** - Same as other explainers
3. **OBS recordings** (optional) - weagan repo tour, code walkthrough

---

## Next Steps

1. [ ] Write all narration scripts (work/scripts/*.txt)
2. [ ] Create SVG slides following style guide
3. [ ] Run /style-check on all SVGs
4. [ ] Generate TTS for all scripts
5. [ ] Record VHS demos
6. [ ] Assemble image segments with narration
7. [ ] Concatenate full video
8. [ ] Create preview/index.html
