# tbt4-tt-rs Explainer Video

Throwback Thursday video for [tt-rs](https://github.com/sw-fun/tt-rs), a visual programming environment reimagined in Rust and WebAssembly.

## Video Structure

| # | Segment | Type | Description |
|---|---------|------|-------------|
| 00 | title | Music | Title card (7s) |
| 01 | hook | Narration | Three-level overview |
| 02 | tt1-intro | Narration | Basics level intro |
| 03 | tt2-intro | Narration | Messaging level intro |
| 04 | tt3-intro | Narration | Sensors level intro |
| 05 | fill-the-box-intro | Narration | Demo 1 intro |
| 05d | fill-the-box-demo | OBS | Demo 1 recording |
| 06 | add-numbers-intro | Narration | Demo 2 intro |
| 06d | add-numbers-demo | OBS | Demo 2 recording |
| 07 | copy-widgets-intro | Narration | Demo 3 intro |
| 07d | copy-widgets-demo | OBS | Demo 3 recording |
| 08 | train-robot-intro | Narration | Demo 4 intro |
| 08d | train-robot-demo | OBS | Demo 4 recording |
| 09 | messaging-intro | Narration | tt2 demo intro |
| 09d | messaging-demo | OBS | tt2 demo recording |
| 10 | robot-sensors-intro | Narration | tt3 demo intro |
| 10d | robot-sensors-demo | OBS | tt3 demo recording |
| 99 | cta | Narration | Call to action |
| 99b | epilog | Music | Epilog (12s) |
| 99c | epilog-ext | Music | Music fade (7s) |

## Current Status

**Preview video with closed captions:** `work/clips/preview-full.mp4` (2:09)

### Completed
- [x] Title card with music (7s)
- [x] SVG slides for all intros
- [x] Narration scripts (TTS-ready)
- [x] Fill The Box demo (from OBS)
- [x] Add Numbers demo (from OBS)
- [x] Epilog with music (12s + 7s fade)
- [x] Preview video with burnt-in captions

### Still Needed
- [ ] TTS audio generation (VoxCPM server offline)
- [ ] Copy Widgets demo (OBS has error, needs re-record)
- [ ] Train a Robot demo (not recorded)
- [ ] Messaging demo (not recorded)
- [ ] Robot with Sensors demo (not recorded)
- [ ] Avatar lip-sync

## OBS Recording Analysis

Source: `~/Movies/2026-02-19 13-22-02.mp4` (2:44, 3024x1862)

| Section | Time | Duration | Status |
|---------|------|----------|--------|
| tt1 hovertext tour | 0:00-0:45 | 45s | Available (not used) |
| tt2 hovertext tour | 0:45-1:25 | 40s | Available (not used) |
| tt3 hovertext tour | 1:25-1:40 | 15s | Available (not used) |
| Fill the Box | 1:40-2:05 | 25s | Extracted |
| Add Numbers | 2:05-2:30 | 25s | Extracted |
| Copy Widgets | 2:30-2:44 | 14s | **ERROR - needs re-record** |

See `work/obs-analysis.md` for detailed frame analysis.

## Assets Created

### SVG Slides
- `01-hook.svg` - Three-level overview
- `02-tt1-intro.svg` - Basics level intro
- `03-tt2-intro.svg` - Messaging level intro
- `04-tt3-intro.svg` - Sensors level intro
- `05-fill-the-box-intro.svg` - Demo 1 intro
- `06-add-numbers-intro.svg` - Demo 2 intro
- `07-copy-widgets-intro.svg` - Demo 3 intro
- `08-train-robot-intro.svg` - Demo 4 intro
- `09-messaging-intro.svg` - tt2 demo intro
- `10-robot-sensors-intro.svg` - tt3 demo intro
- `99-cta.svg` - Call to action

### Narration Scripts
All scripts in `work/scripts/` follow TTS guidelines:
- Periods and commas only
- Numbers spelled out
- Under 320 characters each

## Hashtags

```
#VibeCoding #PersonalSoftware #MLStudy #VisualProgramming #Rust #WebAssembly #ToonTalk #ThrowbackThursday #Programming #Coding #Education
```
