# BabyAI HRM Training Visualization - Production Plan

An explainer video about visualizing hierarchical AI training using a classic key-door puzzle.

> **Reference**: See [Video Pipeline Guide](../../docs/tools.md) for tool documentation.

---

## Project Info

| Field | Value |
|-------|-------|
| **Project** | babyai-hrm |
| **Video Title** | Visualizing How AI Learns: HRM Training |
| **Subject Repo** | ../viz-hrm-ft |
| **Target Duration** | ~4 minutes |
| **Target Audience** | ML study groups, students (accessible, not too deep) |
| **Format** | Animated explainer (SVG + voiceover, avatar on hook/CTA) |
| **Music** | pulsar.mp3 (title + epilog extension) |

---

## Research Summary

### What is BabyAI?

- **Origin**: Research platform for studying grounded language learning (Chevalier-Boisvert et al., ICLR 2019)
- **Environment**: Grid worlds with keys, doors, and navigation tasks
- **Classic Task**: Agent must find key, pick it up, navigate to door, unlock it
- **Use Case**: Benchmarking sample efficiency in learning algorithms

### What is HRM (Hierarchical Reasoning Model)?

- **Paper**: arXiv:2506.21734 (June 2025)
- **Architecture**: Two interdependent recurrent modules
  - High-level module: Slow, abstract planning (the "Planner")
  - Low-level module: Rapid, detailed computation (the "Doer")
- **Size**: 27 million parameters
- **Key Feature**: Executes reasoning in single forward pass, no pre-training needed
- **Performance**: Near-perfect on Sudoku, optimal path-finding in large mazes

### What is TRM (Tiny Recursive Model)?

- **Paper**: arXiv:2510.04871 (October 2025)
- **Improvement**: Significantly higher generalization than HRM
- **Architecture**: Single tiny network (vs HRM's two networks)
- **Size**: 7 million parameters (vs HRM's 27M)
- **Key Insight**: Simpler recursive approach outperforms more complex hierarchical one
- **Notable**: 45% accuracy on ARC-AGI-1 with <0.01% of LLM parameters

### HRM vs LLM Comparison

| Aspect | HRM/TRM | Large LLMs |
|--------|---------|------------|
| **Parameters** | 7-27M | Billions |
| **Pre-training** | Not required | Massive datasets |
| **Speed** | Fast inference | Slower |
| **Scope** | Specialized tasks | General purpose |
| **Training Data** | ~1000 examples | Trillions of tokens |

### The Visualization (viz-hrm-ft)

**Environment**: 10-cell row (cells 0-9)
- Person starts in middle
- Key placed randomly
- Door at cell 9 (locked)

**The Hierarchy**:
- **Planner**: Decides "what to do" (get key → open door)
- **Doer**: Executes "how to do it" (move left/right, pick, open)

**Training Transformation**:
| State | Accuracy | Steps | Behavior |
|-------|----------|-------|----------|
| Untrained | ~30% | 30-40 | Random wandering |
| Trained | ~95% | 8-10 | Efficient path |

**Features**:
- 7-step interactive tutorial
- Live "thought bubble" visualization
- 10 optimal training examples
- Free exploration mode

---

## Narrative Structure

### Part 1: INTRO (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 01-title | Title card + music | (music only, 4s) |
| 02-hook | AI brain with question marks | "What does an AI actually learn during training. Most explanations skip this part." |
| 03-problem | Black box diagram | "Training is usually a black box. Data goes in. A model comes out. But what happens inside." |
| 04-solution | Visualization preview | "This visualization opens the box. Watch an AI transform from random to efficient." |
| 05-preview | Three topic icons | "Today we cover the BabyAI task, hierarchical models, and training visualization." |

### Part 2: BODY (~180s)

#### Section A: The BabyAI Task (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 06-task-intro | 10-cell grid | "The task is simple. A row of ten cells. A person, a key, and a locked door." |
| 07-task-goal | Key + door highlight | "The goal. Find the key, pick it up, go to the door, unlock it." |
| 08-task-untrained | Random path arrows | "Before training, the AI wanders randomly. Thirty to forty steps. Often fails." |
| 09-task-trained | Efficient path | "After training, eight to ten steps. Almost always succeeds." |

#### Section B: Hierarchical Models (~50s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 10-hierarchy-why | Single vs layered brain | "Why hierarchy. Complex tasks break into simpler sub-tasks." |
| 11-planner-doer | Two-level diagram | "The H R M uses two modules. A Planner decides what to do. A Doer figures out how." |
| 12-planner-role | High-level goals | "The Planner thinks in goals. Get key. Then open door. Abstract, strategic." |
| 13-doer-role | Low-level actions | "The Doer thinks in actions. Move left. Pick up. Move right. Concrete, tactical." |
| 14-hrm-vs-llm | Size comparison | "H R Ms are tiny. Twenty-seven million parameters. L L Ms have billions." |
| 15-tradeoff | Specialist vs generalist | "The tradeoff. H R Ms are specialized and fast. L L Ms are general but heavy." |
| 16-trm-evolution | HRM to TRM arrow | "T R M improved on H R M. Only seven million parameters. Even better results." |

#### Section C: Training Visualization (~50s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 17-viz-overview | Screenshot of tool | "The visualization shows training in real time. Watch the AI study examples." |
| 18-training-data | 10 examples grid | "Training data. Ten optimal paths. Each shows the shortest way to solve the task." |
| 19-learning-process | Progress bars animating | "As examples process, the Planner and Doer improve. Their progress bars fill." |
| 20-thought-bubbles | AI thinking visualization | "Thought bubbles show decisions. The Planner chooses goals. The Doer picks actions." |
| 21-before-after | Side by side comparison | "The transformation. Random wandering becomes efficient navigation." |

#### Section D: Modes and Exploration (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 22-tutorial-mode | Tutorial steps | "Tutorial mode guides you through seven steps. Introduction to trained model." |
| 23-freeplay-mode | Control buttons | "Freeplay lets you experiment. Reset, test, generate data, train, compare." |
| 24-metrics | Metrics display | "Metrics show improvement. Steps taken, optimal steps, efficiency percentage." |

### Part 3: SUMMARY (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 25-recap-task | Key-door icon | "The BabyAI task. Simple enough to visualize, complex enough to learn from." |
| 26-recap-hrm | Planner-Doer icon | "Hierarchical models split thinking into planning and doing. Small but powerful." |
| 27-recap-viz | Transformation icon | "The visualization opens the black box. See learning happen step by step." |
| 28-key-insight | Lightbulb | "Key insight. AI training is not magic. It is pattern recognition becoming behavior." |
| 29-cta | GitHub links | "Try the visualization yourself. Links below. Thanks for watching." |

---

## Audio Settings

```bash
# Standard padding for clear pacing
--pad-start 0.3 --pad-end 0.3
```

---

## Visual Requirements

### SVGs Needed (~28 unique visuals)

```
assets/svg/
  02-hook.svg           # AI brain with question marks
  03-problem.svg        # Black box diagram
  04-solution.svg       # Visualization preview/teaser
  05-preview.svg        # Three topic icons
  06-task-intro.svg     # 10-cell grid layout
  07-task-goal.svg      # Key + door highlighted
  08-task-untrained.svg # Random wandering path
  09-task-trained.svg   # Efficient direct path
  10-hierarchy-why.svg  # Single vs layered brain
  11-planner-doer.svg   # Two-level architecture
  12-planner-role.svg   # High-level goals
  13-doer-role.svg      # Low-level actions
  14-hrm-vs-llm.svg     # Size comparison bars
  15-tradeoff.svg       # Specialist vs generalist
  16-trm-evolution.svg  # HRM → TRM improvement
  17-viz-overview.svg   # Tool screenshot/mockup
  18-training-data.svg  # 10 examples grid
  19-learning-process.svg # Progress bars
  20-thought-bubbles.svg  # AI decision viz
  21-before-after.svg   # Transformation comparison
  22-tutorial-mode.svg  # Tutorial steps
  23-freeplay-mode.svg  # Control buttons
  24-metrics.svg        # Metrics display
  25-recap-task.svg     # Key-door icon
  26-recap-hrm.svg      # Planner-Doer summary
  27-recap-viz.svg      # Transformation icon
  28-key-insight.svg    # Lightbulb insight
  29-cta.svg            # GitHub/links CTA
```

---

## Tool Locations

```bash
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR="/Users/mike/github/softwarewrighter/explainer/projects/babyai-hrm/work"
MUSIC="$REFDIR/music/pulsar.mp3"

VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_AVATAR="$TOOLS/vid-avatar"
VID_LIPSYNC="$TOOLS/vid-lipsync"
VID_COMPOSITE="$TOOLS/vid-composite"
VID_CONCAT="$TOOLS/vid-concat"
```

---

## Production Steps

### Step 1: Write Scripts
```bash
# One script per segment (max 200 chars, 2 sentences)
work/scripts/02-hook.txt
work/scripts/03-problem.txt
# ... etc
```

### Step 2: Generate Audio
```bash
for script in work/scripts/*.txt; do
  name=$(basename "$script" .txt)
  $VID_TTS --script "$script" \
    --output "work/audio/${name}.wav" \
    --pad-start 0.3 --pad-end 0.3 \
    --print-duration
done
```

### Step 3: Create SVGs
```bash
# Create ~28 unique SVGs in assets/svg/
# Each should be 1920x1080, dark theme, clear visuals
# Consider using screenshots from viz-hrm-ft for some slides
```

### Step 4: Build Video Clips
```bash
# Title clip with music
$VID_IMAGE --image assets/images/title.jpg \
  --output work/clips/01-title.mp4 \
  --duration 4.0 \
  --music "$MUSIC" \
  --music-offset 15 --volume 0.3

# Content clips with voiceover
for audio in work/audio/*.wav; do
  name=$(basename "$audio" .wav)
  rsvg-convert -w 1920 -h 1080 "assets/svg/${name}.svg" -o "work/stills/${name}.png"
  $VID_IMAGE --image "work/stills/${name}.png" \
    --output "work/clips/${name}.mp4" \
    --audio "$audio" \
    --effect ken-burns
done
```

### Step 5: Avatar Composites (Hook + CTA)
```bash
# Stretch avatar, lipsync, composite for 02-hook and 29-cta
```

### Step 6: Concatenate
```bash
ls work/clips/*.mp4 | sort > work/clips/concat-list.txt
echo "$REFDIR/epilog/99b-epilog.mp4" >> work/clips/concat-list.txt
$VID_CONCAT --list work/clips/concat-list.txt \
  --output work/babyai-hrm-draft.mp4 \
  --reencode
```

---

## YouTube Metadata

### Title
"Visualizing How AI Learns: HRM Training on BabyAI"

### Description
```
What actually happens when an AI learns?

This video uses an interactive visualization to show hierarchical AI training
on a classic key-door puzzle. Watch an agent transform from random wandering
to efficient problem-solving.

In this video:
- 0:00 Introduction
- 0:30 The BabyAI Task
- 1:00 Hierarchical Models (HRM, TRM)
- 1:50 Training Visualization
- 2:40 Tutorial & Exploration Modes
- 3:10 Summary

Try it yourself: https://github.com/wrightmikea/viz-hrm-ft

Research Papers:
- HRM: https://arxiv.org/abs/2506.21734
- TRM: https://arxiv.org/abs/2510.04871
- BabyAI: https://arxiv.org/abs/1810.08272

#AI #MachineLearning #HRM #TRM #BabyAI #Visualization #Training #vibecoding
```

---

## Script Guidelines

### Rules for VibeVoice TTS
1. Max 200 characters per script file
2. Max 2 sentences per script file
3. Only periods and commas (no question marks, colons, semicolons)
4. Spell out acronyms: "H R M" not "HRM", "L L M" not "LLM", "T R M" not "TRM"
5. Short sentences work best

---

## Segment Summary

| Section | Segments | Est. Duration |
|---------|----------|---------------|
| Intro | 4 narrated | ~25s |
| BabyAI Task | 4 | ~30s |
| Hierarchical Models | 7 | ~50s |
| Training Viz | 5 | ~50s |
| Modes | 3 | ~30s |
| Summary | 5 | ~30s |
| **Total** | **28 narrated** | **~215s (~3:35)** |

Plus title (4s) + epilog (12.8s) + extension (5s) = **~240s (~4:00)**

---

## Open Questions

1. **Screenshots vs SVGs**: Should some slides use actual screenshots from viz-hrm-ft?
2. **Screen recording**: Would a short screen recording of the training animation add value?
3. **Music selection**: What mood? (Educational/upbeat vs contemplative)
