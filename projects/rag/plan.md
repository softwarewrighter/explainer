# RAG Explainer Video - Production Plan

A short explainer video about Retrieval-Augmented Generation (RAG) using static SVG visuals with voiceover.

> **Reference**: See [Video Pipeline Guide](../../docs/tools.md) for tool documentation.

---

## Project Info

| Field | Value |
|-------|-------|
| **Project** | rag |
| **Video Title** | RAG: Teaching AI to Look Things Up |
| **Subject Repo** | ../rag-demo |
| **Target Duration** | ~4 minutes |
| **Format** | Animated explainer (static SVG + voiceover, no avatar) |

---

## Research Summary

### RAG in General

**Problem Solved**: Large Language Models hallucinate and lack access to private/current data. RAG solves this by retrieving relevant context before generating answers.

**Core Concept**: Instead of relying on training data alone, RAG systems:
1. Convert documents into vector embeddings (semantic fingerprints)
2. Store embeddings in a vector database
3. When queried, find semantically similar documents
4. Provide those documents as context to the LLM
5. Generate grounded, accurate answers

### Vector Database Landscape (2025)

| Database | Type | Best For |
|----------|------|----------|
| **Qdrant** | OSS + Managed | Performance, cost-sensitive, local-first |
| **Pinecone** | Managed | Enterprise SaaS, minimal ops |
| **Weaviate** | OSS + Managed | Hybrid search, GraphQL API |
| **pgvector** | PostgreSQL extension | Teams already using Postgres |
| **Milvus** | OSS | Billion-scale deployments |
| **Chroma** | OSS | Prototyping, lightweight |

### rag-demo Implementation Highlights

**Key Innovation**: Hierarchical parent-child chunking
- Parent chunks (~3,500 chars): Full context preservation
- Child chunks (~750 chars): Precise retrieval targets
- Research shows 8.2% improvement over baseline chunking

**Tech Stack**:
- **Qdrant**: Vector database (Rust, HNSW indexing)
- **Ollama**: Local LLM server (no cloud APIs)
- **nomic-embed-text**: 768-dim embedding model
- **llama3.2**: Default LLM for generation
- **Rust**: 12 CLI tools (~3,850 LOC)

**Performance**:
- Vector search: 50-80ms
- Full RAG query: 2-5 seconds
- Tested on 97MB of PDFs (9,193 vectors)

---

## Narrative Structure

### Part 1: INTRO - "Tell them what you are going to tell them" (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 01-title | Title card + music | (music only, 4s) |
| 02-hook | Brain with question marks | "What if AI could look things up, instead of just guessing." |
| 03-problem | Hallucination visual | "Language models make things up. They hallucinate facts, dates, and details." |
| 04-solution | RAG acronym reveal | "Retrieval Augmented Generation fixes this. We call it RAG." |
| 05-preview | Three part roadmap | "Today we cover the problem, the solution, and a real implementation." |

### Part 2: BODY - "Tell them" (~150s)

#### Section A: The Problem (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 06-training-data | Book with lock | "Language models learn from training data. Once trained, they cannot learn new things." |
| 07-knowledge-cutoff | Calendar with X | "They have a knowledge cutoff. Ask about yesterday, and they have no idea." |
| 08-private-data | Locked filing cabinet | "They cannot see your private documents. Your company data is invisible to them." |
| 09-hallucination | Confident but wrong | "Without real information, they make confident guesses. These guesses are often wrong." |

#### Section B: The RAG Solution (~40s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 10-rag-overview | RAG architecture diagram | "RAG adds a retrieval step. Before answering, the AI searches your documents." |
| 11-embeddings | Document to numbers | "First, we convert documents into numbers. These numbers capture meaning, not just words." |
| 12-vector-db | Database with vectors | "These numbers go into a vector database. It finds similar content in milliseconds." |
| 13-semantic-search | Query to results | "When you ask a question, we search for relevant passages. Meaning matters, not keywords." |
| 14-context-inject | LLM with context | "The retrieved passages become context. Now the AI answers with real information." |
| 15-grounded | Checkmark on answer | "The answer is grounded in your documents. No more hallucinations about your data." |

#### Section C: Vector Databases (~35s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 16-why-vectors | Traditional vs vector | "Traditional databases search by keywords. Vector databases search by meaning." |
| 17-hnsw | Graph structure | "They use clever algorithms like H N S W. This makes searches fast, even with millions of vectors." |
| 18-db-landscape | Database logos | "Many options exist. Pinecone, Weaviate, Qdrant, Milvus, and more." |
| 19-qdrant-choice | Qdrant highlighted | "We chose Qdrant. It is open source, written in Rust, and runs locally." |
| 20-privacy | Shield icon | "Local means private. Your documents never leave your machine." |

#### Section D: Implementation Deep Dive (~45s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 21-chunking-problem | Long document | "Documents are long. Embeddings work best on shorter passages." |
| 22-chunking-naive | Equal slices | "The naive approach cuts documents into equal pieces. This breaks sentences and loses context." |
| 23-chunking-hierarchical | Parent child tree | "Hierarchical chunking is smarter. Parents hold full sections. Children are smaller pieces." |
| 24-search-children | Magnifying glass on children | "We search the children for precision. They point to exactly what you need." |
| 25-return-parents | Arrow to parent | "We return the parents for context. You get the full picture, not just fragments." |
| 26-research-backing | Chart showing improvement | "Research shows eight percent better accuracy. The right chunking strategy matters." |
| 27-ollama | Ollama logo | "We use Ollama for local inference. No API keys, no cloud, no costs." |
| 28-rust-tools | Terminal with Rust | "Twelve Rust tools handle the pipeline. Fast, safe, and reliable." |

### Part 3: SUMMARY - "Tell them what you told them" (~30s)

| Segment | Visual | Narration |
|---------|--------|-----------|
| 29-recap-problem | Split brain | "Language models hallucinate because they lack information." |
| 30-recap-solution | RAG flow mini | "RAG retrieves real documents before answering." |
| 31-recap-impl | Qdrant plus Ollama | "Our implementation uses Qdrant and Ollama. Fully local, fully private." |
| 32-key-insight | Tagline visual | "The key insight is simple. Ground your AI in real data." |
| 33-cta | GitHub links | "Links to the code and documentation are in the description. Thanks for watching." |

---

## Audio Settings

```bash
# Reduced padding for tight pacing
--pad-start 0.3 --pad-end 0.3

# Example:
$VID_TTS --script work/scripts/02-hook.txt \
  --output work/audio/02-hook.wav \
  --pad-start 0.3 --pad-end 0.3 \
  --print-duration
```

---

## Visual Requirements

### SVGs Needed (33 unique visuals)

```
assets/svg/
  01-title.svg          # Title card (or use image)
  02-hook.svg           # Brain with question marks
  03-problem.svg        # Hallucination concept
  04-solution.svg       # RAG acronym
  05-preview.svg        # Three part roadmap
  06-training-data.svg  # Book with lock
  07-knowledge-cutoff.svg # Calendar with X
  08-private-data.svg   # Filing cabinet locked
  09-hallucination.svg  # Confident wrong answer
  10-rag-overview.svg   # RAG architecture
  11-embeddings.svg     # Document to vectors
  12-vector-db.svg      # Vector database visual
  13-semantic-search.svg # Query matching
  14-context-inject.svg # LLM with retrieved context
  15-grounded.svg       # Verified answer
  16-why-vectors.svg    # Keyword vs semantic
  17-hnsw.svg           # Graph algorithm
  18-db-landscape.svg   # Database comparison
  19-qdrant-choice.svg  # Qdrant highlighted
  20-privacy.svg        # Local privacy shield
  21-chunking-problem.svg # Long document problem
  22-chunking-naive.svg # Bad chunking
  23-chunking-hierarchical.svg # Parent-child tree
  24-search-children.svg # Search precision
  25-return-parents.svg # Context retrieval
  26-research-backing.svg # 8% improvement chart
  27-ollama.svg         # Ollama local LLM
  28-rust-tools.svg     # Rust CLI tools
  29-recap-problem.svg  # Problem recap
  30-recap-solution.svg # Solution recap
  31-recap-impl.svg     # Implementation recap
  32-key-insight.svg    # Ground AI in data
  33-cta.svg            # GitHub links
```

---

## Tool Locations

```bash
TOOLS="/Users/mike/github/softwarewrighter/video-publishing/tools/target/release"
REFDIR="/Users/mike/github/softwarewrighter/video-publishing/reference"
WORKDIR="/Users/mike/github/softwarewrighter/explainer/projects/rag/work"

VID_TTS="$TOOLS/vid-tts"
VID_IMAGE="$TOOLS/vid-image"
VID_CONCAT="$TOOLS/vid-concat"
VID_MUSIC="$TOOLS/vid-music"
VID_SPEEDUP="$TOOLS/vid-speedup"
```

---

## Production Steps

### Step 1: Write Scripts
```bash
# One script per segment (max 200 chars, 2 sentences)
# Use simple punctuation (periods, commas only)
# No ALL-CAPS words (use "h n s w" not "HNSW")
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
# Create 33 unique SVGs in assets/svg/
# Each should be 1920x1080, dark theme, clear visuals
```

### Step 4: Convert SVGs to PNG
```bash
for svg in assets/svg/*.svg; do
  name=$(basename "$svg" .svg)
  rsvg-convert -w 1920 -h 1080 "$svg" -o "work/png/${name}.png"
done
```

### Step 5: Build Video Clips
```bash
# Title clip with music
$VID_IMAGE --image work/png/01-title.png \
  --output work/clips/01-title.mp4 \
  --duration 4.0 \
  --music "$REFDIR/music/swing9.mp3" \
  --music-offset 15 --volume 0.3

# Content clips with voiceover and Ken Burns effect
for audio in work/audio/*.wav; do
  name=$(basename "$audio" .wav)
  $VID_IMAGE --image "work/png/${name}.png" \
    --output "work/clips/${name}.mp4" \
    --audio "$audio" \
    --effect ken-burns
done
```

### Step 6: Concatenate
```bash
ls work/clips/*.mp4 | sort > work/clips/concat-list.txt
# Add epilog
echo "$REFDIR/epilog/99b-epilog.mp4" >> work/clips/concat-list.txt
$VID_CONCAT --list work/clips/concat-list.txt \
  --output work/rag-explainer-draft.mp4 \
  --reencode
```

### Step 7: Add Epilog Extension
```bash
# Extract frame from epilog and create 5s extension with music
$VID_FRAMES --input "$REFDIR/epilog/99b-epilog.mp4" \
  --output work/stills --start 5.0 --count 1
$VID_IMAGE --image work/stills/frame_00001.png \
  --output work/clips/99c-epilog-ext.mp4 \
  --duration 5.0 \
  --music "$REFDIR/music/swing9.mp3" \
  --music-offset 60 --volume 0.3
# Append to concat list and re-concatenate
```

---

## YouTube Metadata

### Title
"RAG Explained: How AI Learns to Look Things Up"

### Description
```
What if your AI could access your documents instead of making things up?

Retrieval-Augmented Generation (RAG) solves the hallucination problem by grounding AI in real data.

In this video:
- 0:00 Introduction
- 0:30 The Problem (hallucinations, knowledge cutoffs)
- 1:00 The RAG Solution (embeddings, vector search)
- 1:40 Vector Databases (Qdrant, Pinecone, Weaviate)
- 2:15 Implementation (hierarchical chunking, Ollama)
- 3:15 Summary and Key Insights

Code: https://github.com/softwarewrighter/rag-demo
Documentation: https://github.com/softwarewrighter/rag-demo/wiki

Vector Database Comparison (2025):
- Qdrant: https://qdrant.tech
- Pinecone: https://pinecone.io
- Weaviate: https://weaviate.io
- pgvector: https://github.com/pgvector/pgvector

#RAG #AI #VectorDatabase #LLM #Qdrant #MachineLearning #Embeddings
```

---

## Script Guidelines

### Rules for VibeVoice TTS
1. Max 200 characters per script file
2. Max 2 sentences per script file
3. Only periods and commas (no dashes, colons, semicolons, question marks, exclamation marks)
4. No ALL-CAPS words (use "h n s w" not "HNSW", "r a g" not "RAG")
5. Short sentences work best
6. Split long narrations into multiple files

### Pacing
- Use `--pad-start 0.3 --pad-end 0.3` for tight pacing
- Consider 1.1x speedup on final video if still too slow

---

## File Organization

```
projects/rag/
+-- plan.md              # This file
+-- docs/
|   +-- research.md      # RAG research notes
+-- assets/
|   +-- images/          # Title card, photos
|   +-- svg/             # 33 unique SVG visuals
+-- work/
    +-- scripts/         # Narration text (02-*.txt through 33-*.txt)
    +-- audio/           # TTS audio (.wav)
    +-- png/             # Converted SVGs
    +-- clips/           # Individual video clips
    +-- stills/          # Extracted frames
    +-- rag-explainer-draft.mp4  # Final draft
```

---

## Segment Word Counts

Target: ~15-25 words per segment for natural pacing

| Section | Segments | Est. Words | Est. Duration |
|---------|----------|------------|---------------|
| Intro | 4 narrated | ~60 | ~25s |
| Problem | 4 | ~80 | ~30s |
| RAG Solution | 6 | ~120 | ~45s |
| Vector DBs | 5 | ~80 | ~30s |
| Implementation | 8 | ~140 | ~55s |
| Summary | 5 | ~70 | ~30s |
| **Total** | **32 narrated** | **~550** | **~215s (~3:35)** |

Plus title (4s) + epilog (12.8s) + extension (5s) = **~240s (~4:00)**
