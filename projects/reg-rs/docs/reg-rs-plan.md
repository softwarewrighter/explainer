# reg-rs Explainer Video - Project Status

**Status:** PAUSED (2026-03-15)

## Video Structure (13 clips)

| # | Segment | Type | Clip Status | Audio Status |
|---|---------|------|-------------|--------------|
| 00 | Title | bookend | DONE | DONE (music) |
| 01 | Hook | slide+audio | DONE | DONE |
| 02 | Overview | slide+audio | **STALE** - needs rebuild with Mar 14 audio | DONE (Mar 14) |
| cli-00 | CLI Intro | slide+audio | **STALE** - needs rebuild with Mar 14 audio | DONE (Mar 14) |
| cli-01 | Basic Workflow | VHS+audio | **STALE** - needs VHS re-record + Mar 14 audio | DONE (Mar 14) |
| cli-02 | Regression Demo | VHS+audio | **STALE** - needs VHS re-record + Mar 14 audio | DONE (Mar 14) |
| cli-03 | Dogfood Demo | VHS+audio | **STALE** - needs VHS re-record + Mar 14 audio | DONE (Mar 14) |
| cli-sum | CLI Summary | slide+audio | **STALE** - needs rebuild with Mar 14 audio | DONE (Mar 14) |
| sum | History | slide+audio | DONE | DONE |
| web-00 | Web Intro | slide+audio | DONE | DONE |
| cta | Call to Action | slide+audio | DONE | DONE |
| 99 | Subscribe Reminder | bookend | DONE (shared) | DONE (narration) |
| 99x | Outro | bookend | DONE | DONE (music) |

## What Changed (Mar 14 overhaul)

reg-rs switched from raw `regress` subcommands to shell aliases and from binary .tdb-only storage to git-friendly text files (.rgt/.out/.err) with .tdb as gitignored cache.

### New aliases
- `adrg` - add/create test
- `rnrg` - run tests
- `lsrg` - list tests
- `shrg` - show test details
- `uprg` - rebase (accept new output)
- `rmrg` - remove test

### Updated assets (all done)
- `assets/svg/cli-00-intro.svg` - aliases instead of raw commands
- `assets/svg/cli-summary.svg` - alias checklist, git-friendly note
- `assets/svg/02-overview.svg` - text-based storage instead of SQLite
- `assets/vhs/cli-01-basic.tape` - alias commands
- `assets/vhs/cli-02-regression.tape` - alias commands
- `assets/vhs/cli-03-dogfood.tape` - alias commands
- All 6 narration scripts in `work/scripts/` updated
- All 6 TTS audio files regenerated and whisper-verified

### Stills rendered (all done)
- `work/stills/cli-00-intro.png`
- `work/stills/cli-summary.png`
- `work/stills/02-overview.png`

## Remaining Work to Resume

1. **Record 3 VHS tapes** - tapes are written but not yet recorded
   - `assets/vhs/cli-01-basic.tape` → `recordings/cli-01-basic.mp4`
   - `assets/vhs/cli-02-regression.tape` → `recordings/cli-02-regression.mp4`
   - `assets/vhs/cli-03-dogfood.tape` → `recordings/cli-03-dogfood.mp4`

2. **Rebuild 3 slide+audio clips** (still + new audio)
   - `02-overview.mp4` from `work/stills/02-overview.png` + `work/audio/02-overview-raw.wav`
   - `cli-00-intro.mp4` from `work/stills/cli-00-intro.png` + `work/audio/cli-00-intro-raw.wav`
   - `cli-summary.mp4` from `work/stills/cli-summary.png` + `work/audio/cli-summary-raw.wav`

3. **Build 3 VHS+audio clips** (VHS recording + new audio)
   - `cli-01-basic.mp4` - audio 14.56s (if video > audio: `apad`; if audio > video: `tpad=stop_mode=clone`)
   - `cli-02-regression.mp4` - audio 23.20s
   - `cli-03-dogfood.mp4` - audio 20.64s

4. **Normalize all 6 rebuilt clips** with `./scripts/normalize-volume.sh`

5. **Concatenate** with `vid-concat` using `work/clips/concat-list.txt`

6. **Update preview HTML** (`work/preview/index.html`) with new whisper transcriptions

7. **Review and finalize**

## Notes

- VHS tapes verified compatible with current reg-rs binary (Mar 15)
- `reg-rs run` now exits code 1 on regressions (commit b08ade1) - no VHS impact
- Newer subcommands (analyze, report, reset, migrate, complete, status) exist but are out of scope
- Delete `assets/svg/cta.svg` - was created erroneously, CTA uses `assets/web.png` instead
