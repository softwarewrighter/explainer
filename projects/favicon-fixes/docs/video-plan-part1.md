# Favicon CLI Video Series - Part 1 Plan

## Series Overview

A two-part "vibe-coding" series documenting the process of using AI coding agents to discover bugs, document issues, and improve a Rust CLI tool.

---

## Video Titles

### Part 1 (This Video)
**Primary**: "Vibe Coding: AI Agent Finds 4 Bugs in My Favicon Tool"
**Alt 1**: "I Let Claude Code Test My CLI Tool - Here's What Broke"
**Alt 2**: "AI-Powered Bug Hunting: Testing a Rust CLI with Claude Code"

### Part 2 (Tomorrow)
**Primary**: "Vibe Coding: AI Agent Fixes the Bugs It Found"
**Alt 1**: "Claude Code Fixes Its Own Bug Reports"
**Alt 2**: "From Bug Report to Pull Request with AI Coding Agents"

---

## Hooks

### Part 1 Hook
"I asked an AI coding agent to demo my favicon generator. It found four bugs, two missing features, and a documentation gap. This is vibe coding."

### Part 2 Hook (for tomorrow)
"Yesterday an AI found bugs in my code. Today it fixes them. Let's see if vibe coding can close the loop."

---

## Part 1 CTA
"In the next video, we'll fix these bugs and add the missing features using the same AI agent. Subscribe to see vibe coding in action."

---

## Video Description (YouTube)

```
An AI coding agent demos my Rust favicon generator and discovers bugs I never knew existed.

This is "vibe coding" - using AI coding agents not just to write code, but to test, document, and improve it. In this video, Claude Code runs through a demo guide, hits errors, adapts on the fly, and produces a detailed bug report.

Bugs Found:
- Named colors (like "red") not supported
- "transparent" rejected as background color
- PNG output filename mismatch
- Missing emoji font documentation

What Worked:
- Text favicons with hex colors
- Unicode symbols (after font install)
- Rotation and animated GIFs
- Transparent background flag

Tools used:
- Claude Code (AI coding agent)
- favicon CLI (Rust)
- VibeVoice TTS
- MuseTalk lip-sync

Part 2 coming tomorrow: The AI fixes what it found.

#vibecoding #rustlang #cli #aicoding #claudecode
```

---

## Video Structure

### Opening (0:00-0:15)
- **Slide**: Hook slide with avatar
- **Narration**: Hook text with lip-sync

### Act 1: Setup (0:15-1:30)
OBS footage of Claude Code starting the demo

### Act 2: Text Favicons Work (1:30-2:30)
OBS footage showing successful text favicon generation

### Act 3: First Errors (2:30-4:00)
OBS footage showing PNG naming issue, unicode panic

### Act 4: Adapting (4:00-5:30)
Claude Code recognizes missing font, pivots to text-only demos

### Act 5: Color Errors (5:30-6:30)
OBS footage showing "red" color rejection, hex workaround

### Act 6: What Works (6:30-7:30)
Rotation, transparent flag, animated GIFs

### Act 7: Font Installation (7:30-8:30)
Installing noto-fonts-emoji, re-running unicode demos

### Act 8: Unicode Success (8:30-9:30)
Coffee, heart, fire emojis working

### Act 9: More Issues (9:30-10:00)
"transparent" color rejection, workaround with -T flag

### Act 10: Summary (10:00-10:20)
Final summary of generated files

### Closing (10:20-10:30)
- **Slide**: CTA slide with avatar
- **Narration**: CTA text with lip-sync

---

## Narration Segments

Each segment is ~8 seconds of narration for ~10 seconds of video.
Format: [Timestamp] - Narration text

### Opening
[00:00] Hook slide with avatar lip-sync (see hook text above)

### Act 1: Setup (Frames 1-25)
[00:15] "Here's Claude Code, an AI coding agent, about to run through a demo guide I created for my favicon generator tool."

[00:25] "The tool generates favicon images from text or unicode symbols. Simple enough, right?"

[00:35] "I asked Claude to execute each demo command, display the results, and document what happens."

[00:45] "This is vibe coding. Instead of manually testing, I'm letting the AI explore and report back."

[00:55] "The demo guide covers text favicons, colors, unicode symbols, rotation, and animated GIFs."

[01:05] "Let's see what breaks."

[01:15] "First up, Demo 1: basic text favicons. Generate AB, X, and SW as favicon images."

### Act 2: Text Favicons (Frames 30-45)
[01:25] "The AB favicon works. Two letters rendered on a transparent background."

[01:35] "Notice the checkered pattern in the preview. That's ImageMagick showing transparency, not a bug."

[01:45] "Next, single letter X as a PNG file."

[01:55] "Hmm, first issue. The command saved as favicon dot ico, but tried to display favicon dot png."

[02:05] "The dash dash png flag didn't change the default output filename. That's bug number one."

[02:15] "The display command fails because the file doesn't exist at that path."

### Act 3: First Errors (Frames 50-70)
[02:25] "Moving on to unicode symbols. This should show a rocket emoji."

[02:35] "And we get our first crash. Thread panicked, no fonts available on system."

[02:45] "The tool is looking for an emoji font to render the rocket symbol, but this Linux system doesn't have one installed."

[02:55] "Claude checks for Noto Color Emoji font. Not found."

[03:05] "This isn't a bug in the code. It's a documentation gap. The README should mention emoji font requirements."

[03:15] "For Linux users, you need to install noto fonts emoji package."

[03:25] "The AI recognizes this and decides to skip unicode demos for now and continue with text-based features."

[03:35] "Smart adaptation. Instead of getting stuck, it moves forward with what works."

[03:45] "Let me continue with the text-based demos that do work and show what we can preview."

### Act 4: Adapting (Frames 75-85)
[03:55] "Demo 4: Custom colors. White A on blue background."

[04:05] "Using hex color codes like hashtag FFFFFF for white and hashtag 0066CC for blue."

[04:15] "That works. Saved as white on blue dot ico."

[04:25] "Now let's try red X on black. But wait, the demo guide says dash f red, dash b black."

[04:35] "Error: Invalid foreground color red. Named colors aren't supported."

[04:45] "That's bug number two. The tool only accepts hex codes, not CSS color names."

[04:55] "This is actually a reasonable feature to add. Red, black, white, blue are common enough."

[05:05] "Claude adapts again. Uses hex codes FF0000 for red and 000000 for black."

[05:15] "Now it works. We have a workaround, but we should add named color support."

### Act 5: More Features (Frames 90-100)
[05:25] "Demo 5: Rotation. Letter R rotated 45 degrees clockwise."

[05:35] "The dash r flag works. We can see the R tilted in the preview."

[05:45] "Counter-clockwise rotation with dash capital R also works. 90 degrees the other way."

[05:55] "Transparent background with the dash capital T flag. That works too."

[06:05] "So far: hex colors work, rotation works, transparent flag works."

[06:15] "Demo 6: Animated GIFs. Spinning S with 30 degree rotation per frame."

[06:25] "The animation generates, but the rotation looks slow. 30 degrees per frame isn't very dynamic."

[06:35] "That's something to note for the demo guide. Use larger rotation values for smoother animation."

### Act 6: Summary and Font Install (Frames 110-130)
[06:45] "Claude summarizes what worked so far. Text favicons, hex colors, rotation, animated GIFs."

[06:55] "Skipped demos 2 and 3, the unicode features, because no emoji font is installed."

[07:05] "Now here's where it gets interesting. Claude suggests installing the font."

[07:15] "Sudo pacman dash S noto fonts emoji. This is an Arch Linux system."

[07:25] "The font package downloads and installs. About 10 megabytes."

[07:35] "Font cache updates. Now let's re-run the unicode demos."

[07:45] "Checking fc-list for emoji fonts. Noto Color Emoji is now available."

### Act 7: Unicode Success (Frames 150-170)
[07:55] "Demo 2 retry: Unicode symbol by alias. Favicon dash dash unicode rocket."

[08:05] "It works! We have a rocket emoji favicon. No more panics."

[08:15] "Coffee emoji. Beautiful coffee cup on transparent background."

[08:25] "Wrench, star, heart. All the unicode aliases are working now."

[08:35] "Demo 3: Unicode by code point. U plus 1F600 is the grinning face emoji."

[08:45] "2764 without the U plus prefix. That's the heart symbol."

[08:55] "Code points work just like aliases. Both ways to specify unicode characters."

### Act 8: More Issues (Frames 180-195)
[09:05] "Demo 4 revisited with unicode. Star with transparent background."

[09:15] "But the demo guide says dash b transparent. Let's see what happens."

[09:25] "Error: Invalid background color transparent. Bug number three."

[09:35] "The tool has a dash capital T flag for transparency, but doesn't accept the word transparent as a color value."

[09:45] "Easy fix. Use dash T instead. Fire emoji with transparent background works."

[09:55] "Demo 5 with unicode: Rotating wrench. 45 degrees clockwise."

### Act 9: Final Demos (Frames 200-210)
[10:05] "Animated gear spinning. Animated star spinning. Both work with unicode symbols."

[10:15] "All unicode demos complete. 24 files generated total."

[10:25] "Final summary: Unicode aliases rocket, coffee, wrench, star, heart, fire, gear all work."

[10:35] "Code points work. Transparent backgrounds work. Rotation and animation work."

[10:45] "Four bugs found: named colors, transparent as color value, PNG filename, and animation speed defaults."

[10:55] "Plus one documentation gap: emoji font requirements."

### Closing
[11:05] CTA slide with avatar lip-sync (see CTA text above)

---

## Slides Needed

1. **02-hook.svg** - Hook slide for avatar composite
   - Title: "Vibe Coding: Bug Hunting"
   - Subtitle: "AI Agent vs Favicon CLI"
   - Visual: Terminal/code aesthetic

2. **29-cta.svg** - CTA slide for avatar composite
   - Title: "Next: Fixing the Bugs"
   - Subtitle: "Subscribe for Part 2"
   - Visual: Checkmark/fix aesthetic

---

## Production Notes

- Total runtime: ~11:15 (hook + 10:30 OBS + CTA)
- Narration segments: 47 segments
- Avatar clips: 2 (hook, CTA) using curmudgeon.mp4
- Background music: Low volume, continuous
- Transition style: Cut between OBS clips, no fancy transitions
