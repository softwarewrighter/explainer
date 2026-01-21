# Video Segmentation Approach

## Overview

This document describes the two-level segmentation approach for creating narrated explainer videos from OBS screen recordings.

## Problem

- Raw OBS recordings are 30-40+ minutes
- VibeVoice TTS works best with short texts (garbles longer content)
- Need narration that matches what's on screen
- Want minimal dead air (max 2 seconds between narration end and next clip)

## Solution: Two-Level Segmentation

### Level 1: Logical Sections

Identify action boundaries based on content:
- Starting a new task (Bug N, Feature N)
- Running a command (cargo build, clippy, git commit)
- Displaying output (demo images, test results)
- User interaction (questions, confirmations)

These sections can be any length (8s to 60s+) as long as they represent one logical action.

### Level 2: Narration Slots (7-12 seconds each)

For each logical section:
1. Calculate slots: `section_length / 8` (rounded)
2. Assign roles to each slot:
   - **Slot 1 (describe)**: What's happening
   - **Slot 2 (joke)**: Commentary, humor, or additional detail
   - **Slot 3+ (summary)**: Wrap up, transition to next

Example: 24-second section → 3 slots
```
Clip 1 (0-8s):   "Running cargo clippy to check for issues."
Clip 2 (8-16s):  "Clippy has opinions about everything."
Clip 3 (16-24s): "All checks pass. Ready to commit."
```

### Combining Short Sections

If adjacent actions are very short (2-4 seconds each):
- Combine into one 8+ second section
- Write one narration covering all actions

Example: Three 3-second icon displays → One 9-second clip
```
"Displaying wrench, heart, and star icons. All rendering correctly."
```

## File Structure

```
work/
├── segment-map-v2.json      # Section and clip definitions
├── scripts/
│   └── clip-NNN.txt         # Individual narration scripts
├── audio/narration/
│   ├── clip-NNN.wav         # Generated TTS audio
│   └── clip-NNN.used        # Text used for generation (for smart regen)
└── clips/segments/
    ├── clip-NNN.mp4         # Video segments
    └── index.html           # Preview page
```

## segment-map-v2.json Format

```json
{
  "sections": [
    {
      "id": 1,
      "name": "Section name",
      "start": 0,
      "end": 24,
      "duration": 24,
      "clips": [
        {
          "clip_id": "001",
          "start": 0,
          "end": 8,
          "role": "describe",
          "narration": "What's happening in this clip."
        },
        {
          "clip_id": "002",
          "start": 8,
          "end": 16,
          "role": "joke",
          "narration": "Witty commentary about what we're seeing."
        },
        {
          "clip_id": "003",
          "start": 16,
          "end": 24,
          "role": "summary",
          "narration": "Wrapping up this section."
        }
      ]
    }
  ]
}
```

## Narration Guidelines

### Length
- Target: 5-10 seconds of audio per clip
- Video clip: 7-12 seconds
- Dead air: 1-2 seconds max at end of clip

### Style
- Conversational, first-person
- Max 2 sentences per clip
- Use "fave icon" not "favicon" for pronunciation
- Use "to do" not "todo" for pronunciation

### Roles
- **describe**: State what's visible/happening
- **joke**: Light humor, commentary, or interesting observation
- **summary**: Conclude the action, transition to next

## Smart TTS Regeneration

The generation script tracks what text was used for each audio file:
- Stores `.used` file alongside each `.wav`
- Compares current script to `.used` file
- Only regenerates if text changed or audio missing
- Saves time and electricity on re-runs

## Preview HTML

The preview page shows:
- Video player for each clip
- Narration text displayed
- Audio player for TTS output
- Section grouping for context

No auto-refresh (interrupts playback). Manually refresh to see new clips.
