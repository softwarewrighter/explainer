# APL Horse Race - Video Project

## Overview

An explainer video about recreating my first program from 1972, a horse race simulator written in APL on an IBM 360 mainframe accessed via an IBM 2741 Selectric terminal with acoustic coupler modem.

## Historical Context

- **Year**: circa 1972
- **Location**: High school library
- **Hardware**: IBM 2741 terminal (modified Selectric typewriter)
- **Modem**: 134.5 baud acoustic coupler
- **System**: IBM 360 mainframe running APL\360
- **Learning**: Self-paced APL tutorial in a workspace

## Video Structure

| # | Segment | Duration | Type | Content |
|---|---------|----------|------|---------|
| 00 | Title | 5s | Image + modem sounds | acoustic-coupler-box.jpg |
| 01 | Hook | ~15s | SVG + avatar | My first program, 50+ years ago |
| 02 | Context | ~15s | SVG | The 1972 setup: terminal, modem, mainframe |
| 03 | Demo | ~20s | VHS/MP4 | Show the race running |
| 04 | Code Overview | ~15s | PNG/SVG | The source code image |
| 05 | SHOWHORSES | ~15s | SVG | How the display function works |
| 06 | RACE | ~15s | SVG | How the main game loop works |
| 07 | APL Magic | ~15s | SVG | Key APL concepts demonstrated |
| 99 | CTA | ~15s | SVG + avatar | Try GNU APL yourself |
| 99b | Epilog | ~5s | Standard | Like and subscribe |
| 99c | Epilog Ext | 7s | Same as 99b + modem sounds | Modem sounds fade out over last 3s |

## Audio

- **Title (00)**: Dial-up modem sounds, 5 seconds
- **Epilog Extension (99c)**: Dial-up modem sounds, 7 seconds, fade out over last 3s
- **Source**: Public domain from Wikipedia Commons (William Termini)
- **File**: `assets/music/Dial_up_modem_noises.wav`
- **Attribution in description.txt**: Link to https://en.wikipedia.org/wiki/File:Dial_up_modem_noises.ogg

## Source Assets

- `race.apl.png` - Screenshot of the APL source code
- `docs/race-apl-explained.md` - Line-by-line explanation
- `assets/video/apl_horse_race.mp4` - Demo of the program running (31s, 900x650)

## Key Messages

1. APL was revolutionary - array-oriented, interactive, expressive
2. The language is remarkably unchanged after 50+ years
3. Learned to program via self-paced tutorial in a timesharing workspace
4. Simple programs taught powerful concepts

## Technical Highlights to Cover

- `⍴` (reshape) - Creating arrays
- `?` (roll) - Random number generation
- `⊃` (pick) - Array indexing
- `→` (branch) - Control flow with labels
- `/` (reduce and compress) - Aggregation and filtering
- Vectorized operations - No explicit loops for array updates

## Narration Notes

- Use "A P L" not "APL" for TTS
- Spell out "IBM" as "I B M"
- "Selectric" should work
- Numbers spelled out: "nineteen seventy two", "one hundred thirty four point five baud"

## Production Steps

1. [x] Create directory structure
2. [x] Create plan.md (this file)
3. [ ] Write narration scripts
4. [ ] Create SVG slides following style guide
5. [ ] Add VHS/MP4 demo recording
6. [ ] Generate TTS audio (VoxCPM)
7. [ ] Create video clips
8. [ ] Avatar lip-sync for hook and CTA
9. [ ] Add title image and music
10. [ ] Create title clip
11. [ ] Normalize all audio
12. [ ] Concatenate final video

## Project Paths

```
apl/
├── assets/
│   ├── svg/           # SVG slides
│   ├── images/        # Title image (ADD HERE)
│   └── music/         # Music track (ADD HERE)
├── docs/
│   ├── plan.md        # This file
│   └── race-apl-explained.md  # Technical explanation
├── scripts/
│   └── normalize-volume.sh
├── race.apl.png       # Source code screenshot
├── work/
│   ├── scripts/       # Narration scripts
│   ├── audio/         # TTS output
│   ├── clips/         # Final video clips
│   ├── stills/        # PNG renders
│   ├── avatar/        # Lipsync files
│   ├── vhs/           # Demo recordings
│   ├── reference/     # TTS reference audio
│   └── preview/       # Preview with symlinks
│       ├── index.html
│       ├── clips -> ../clips
│       ├── audio -> ../audio
│       ├── stills -> ../stills
│       ├── images -> ../../assets/images
│       └── svg -> ../../assets/svg
└── tts/
    └── client.py      # VoxCPM TTS client
```

## Waiting On

- [x] Title image: `assets/images/acoustic-coupler-box.jpg` (may be replaced with annotated version)
- [x] Music: `assets/music/Dial_up_modem_noises.wav` (public domain, William Termini)
- [x] Demo MP4: `assets/video/apl_horse_race.mp4` (31s, 900x650, needs scale to 1920x1080)
