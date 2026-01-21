# Fix Plan for Draft v6 - Bug #6: Unicode Code Points

## Issue Discovered
At 8:06 in draft-v5, the video shows numbers instead of the expected heart emoji.
The narration incorrectly claims "2764 without the U plus prefix. That is the heart symbol."
and "Code points work just like aliases."

In reality, code points are NOT working - this is a **6th bug**.

## Files to Update

### Narration Scripts (need TTS regeneration)

| File | Current Text | New Text |
|------|-------------|----------|
| `02-hook.txt` | "five bugs" | "six bugs" |
| `54-codepoint2.txt` | "2764 without the U plus prefix. That is the heart symbol." | "2764 without the U plus prefix. That should be the heart symbol. But wait, it shows numbers instead." |
| `55-codepoint3.txt` | "Code points work just like aliases. Both ways to specify unicode characters." | "Wrench bug again? Code points do not seem to work. That is bug number six." |
| `65-final3.txt` | "Code points work. Transparent backgrounds..." | "Code points do not work. Transparent backgrounds..." |
| `66-final4.txt` | "Five bugs found. Named colors, transparent as color value, PNG filename, animation speed defaults, and wrench symbol rendering as text." | "Six bugs found. Named colors, transparent as color value, PNG filename, animation speed defaults, wrench symbol rendering as text, and unicode code points." |

### SVG Slides (need re-rendering)

| File | Change |
|------|--------|
| `02-hook.svg` | Line: "RESULT: 5 bugs" → "RESULT: 6 bugs" |
| `68-cta.svg` | Add 6th bug checkbox: "Unicode code points" |

### Clips to Rebuild

1. **02-hook-composited.mp4** - After updating 02-hook.txt and 02-hook.svg
2. **68-cta-composited.mp4** - After updating 68-cta.svg (narration unchanged)
3. **03-67-obs-aligned-v2.mp4** - After regenerating audio for 54, 55, 65, 66

## Build Steps

1. Update narration text files (5 files)
2. Regenerate TTS audio for: 02, 54, 55, 65, 66
3. Update SVG files (2 files)
4. Rebuild hook clip with new audio + SVG
5. Rebuild CTA clip with new SVG (audio unchanged)
6. Rebuild OBS aligned clip (timeline may need adjustment if audio lengths changed)
7. Fix audio formats to 44100 Hz stereo
8. Concatenate final draft-v6

## Audio Length Impact

If the new narration lengths differ significantly from originals:
- 54: May be longer (added "But wait, it shows numbers instead")
- 55: Similar length (replaced text, similar word count)
- 65: Slightly shorter (removed "Code points work")
- 66: Slightly longer (added "and unicode code points")

The freeze frame logic should handle minor length changes, but may need timeline adjustment if changes are large.
