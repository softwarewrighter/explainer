# cli-midi-rs-plugins Explainer Video Plan

Follow-on video to the midi-cli-rs explainer covering TOML-based custom mood plugins.

## Video Segments

| Segment | Type | Duration Est | Status |
|---------|------|--------------|--------|
| 00-title | Title card | 9s | PENDING |
| 01-hook | SVG + avatar | 15s | narration ready |
| 02-overview | SVG + avatar | 18s | narration ready |
| 03-toml-structure | SVG + avatar | 18s | narration ready |
| 04-demo | VHS terminal | 25-30s | narration ready, VHS PENDING |
| 05-web-ui | OBS recording | 20-25s | narration ready, OBS PENDING |
| 99-cta | SVG + avatar | 12s | narration ready |
| 99b-epilog | Shared asset | 5s | use shared |
| 99c-epilog-ext | Shared asset | 8s | use shared |

**Estimated total: 2-2.5 minutes**

## VHS Tape Approach for Demo Segment

The demo should show the plugin system in action. Suggested approach:

### Option A: Show Plugin File and Generate Music

```tape
Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

# Show the plugin file structure
Type "cat ~/.midi-cli-rs/moods/electronic.toml"
Enter
Sleep 3s

# List available moods including plugin moods
Type "midi-cli-rs moods"
Enter
Sleep 2s

# Generate with a plugin mood
Type "midi-cli-rs preset synthwave -o demo-synthwave.wav"
Enter
Sleep 3s

# Generate with another plugin mood to show variety
Type "midi-cli-rs preset techno -o demo-techno.wav"
Enter
Sleep 2s
```

### Option B: Create Plugin from Scratch

```tape
Set Shell "bash"
Set FontSize 32
Set Width 1920
Set Height 1080
Set Theme "Dracula"
Set TypingSpeed 50ms
Set Padding 20

# Show creating a new plugin file
Type "cat > ~/.midi-cli-rs/moods/my-moods.toml << 'EOF'"
Enter
Type "[pack]"
Enter
Type "name = \"my-moods\""
Enter
Type ""
Enter
Type "[[moods]]"
Enter
Type "name = \"chill-jazz\""
Enter
Type "base_mood = \"jazz\""
Enter
Type "default_tempo = 70"
Enter
Type "default_key = \"Dm\""
Enter
Type "EOF"
Enter
Sleep 2s

# Now use it
Type "midi-cli-rs preset chill-jazz -o my-jazz.wav"
Enter
Sleep 3s
```

### Option C: Combined Approach (Recommended)

Show the existing electronic.toml, then use a plugin mood, demonstrating the end-to-end workflow in about 25 seconds.

## Web UI Recording (OBS)

Show the Plugins tab in the web interface:

1. Start midi-cli-rs serve
2. Navigate to Plugins tab
3. Show list of installed mood packs
4. Click to expand a pack and see mood details
5. Optionally show upload interface

Recording should be ~15-20s of actual content, we'll realign to audio.

## Assets Needed

### From User
- [ ] Title card image (or reuse from midi-cli-rs)
- [ ] VHS tape recording
- [ ] OBS web UI recording

### Generated
- [x] Narration scripts (work/scripts/)
- [x] SVG slides (assets/svg/)
- [ ] TTS audio (run generate-tts.sh)

## Technical Notes

- TTS server: queenbee.local:7860 (not curiosity)
- Avatar: curmudgeon
- Resolution: 1920x1080
- Audio: 44100Hz stereo, normalize to -25dB

## Scope Exclusions

- Dynamic library plugins (future work, not covered)
- Layer configuration details (cinematic.toml advanced features)
- Web Assembly internals
