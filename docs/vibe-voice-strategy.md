# VibeVoice TTS Strategy Guide

This document captures patterns that produce garbled audio with VibeVoice TTS and their workarounds.

## Punctuation Issues

### Problem: Periods mid-sentence
VibeVoice only processes periods properly at the **end of a sentence**.

**Bad:**
```
Files save as .ico instead of .png
```

**Good:**
```
Files save as dot i c o instead of dot p n g.
```

### Problem: Semicolons
VibeVoice does not handle semicolons well.

**Bad:**
```
Display failed; I point out the issue
```

**Good:**
```
Display failed so I point out the issue.
```

### Problem: Apostrophes (contractions)
VibeVoice only handles commas and periods reliably. Contractions with apostrophes cause garbling.

**Bad:**
```
Claude hasn't used display command yet
```

**Good:**
```
Claude has not used display command yet.
```

### Problem: Hyphens in flags/arguments
Command-line flags with hyphens can be mispronounced.

**Bad:**
```
Error shows -fg NOT supported
```

**Good:**
```
Dash f transparent causes an error.
```

## Capitalization Issues

### Problem: ALL CAPS words
VibeVoice does not handle all-caps words well.

**Bad:**
```
One item is PARTIAL
```

**Good:**
```
One item is partial.
```

### Problem: Acronyms and abbreviations
Multi-letter abbreviations get garbled.

**Bad:**
```
transparent fg NOT supported
```

**Good:**
```
transparent foreground not supported.
```

## Number Issues

### Problem: Numeric digits
Numbers as digits can be mispronounced or skipped.

**Bad:**
```
Trying frame delay 10
```

**Good:**
```
Trying a frame delay of ten.
```

## Word Choice Issues

### Problem: Artificially spaced words
Spacing out syllables (e.g., "trans parent") can cause anomalous audio duration (40+ seconds for a short phrase).

**Bad:**
```
trans parent fore ground
```

**Good:**
```
see through foreground
```

**Workaround:** Use synonyms instead of phonetic spelling for multi-syllable words.

### Problem: Technical terms
Some technical terms are consistently mispronounced. Test and reword as needed.

**Known problematic words:**
- "jiff" (for GIF) → sounds like "Jeff" or "girl"
- "demo" → works, but "dem owe" phonetic spelling also works
- "todo" → use "to do" (spaced)
- "transparent foreground" → gets garbled, try rewording

**Workarounds:**
```
# Instead of "jiff file"
animation file

# Instead of "GIF"
animated image

# Instead of "todo"
to do
```

## Sentence Structure Issues

### Problem: Very short phrases
Single-word or very short phrases can produce unexpected output.

**Bad:**
```
Committing
```

**Good:**
```
Now committing.
Wrapping up.
```

### Problem: Complex compound sentences
Long sentences with multiple clauses can drift into garbling.

**Solution:** Break into shorter, simpler sentences.

## Validation Workflow

### Using Whisper for local validation

1. **Extract audio from video:**
```bash
ffmpeg -i video.mp4 -ar 16000 -ac 1 -c:a pcm_s16le audio.wav
```

2. **Generate SRT transcript:**
```bash
whisper-cli -m ~/.local/share/whisper-cpp/models/ggml-medium.en.bin \
  -f audio.wav -osrt -of transcript -t 8
```

3. **Compare transcript to original scripts:**
   - Look for nonsense words
   - Look for wrong words that sound similar
   - Check technical terms and numbers

4. **Test individual clips:**
```bash
whisper-cli -m ~/.local/share/whisper-cpp/models/ggml-medium.en.bin \
  -f clip.wav --no-prints
```

### Using YouTube captions

1. Upload video (unlisted/private)
2. Download auto-generated captions (.srt format)
3. Compare against original scripts
4. Identify clips where YouTube heard nonsense

## Summary of Safe Patterns

| Element | Avoid | Use Instead |
|---------|-------|-------------|
| Mid-sentence periods | `.ico` | `dot i c o` |
| Semicolons | `failed; I point` | `failed so I point` |
| Contractions | `hasn't`, `don't` | `has not`, `do not` |
| ALL CAPS | `PARTIAL` | `partial` |
| Numeric digits | `delay 10` | `delay of ten` |
| Abbreviations | `fg`, `bg` | `foreground`, `background` |
| Hyphens in flags | `-f` | `dash f` |
| Technical jargon | `jiff` | `animation` |
| Compound words | `todo` | `to do` |
| Spaced syllables | `trans parent` | `see through` (use synonyms) |

## Quick Checklist Before TTS Generation

- [ ] All sentences end with periods
- [ ] No semicolons (use "so", "and", or split sentences)
- [ ] No contractions (expand to full words)
- [ ] No ALL CAPS (use lowercase)
- [ ] Numbers written as words
- [ ] File extensions spelled out (dot p n g)
- [ ] Command flags spelled out (dash f)
- [ ] Technical terms tested or avoided
- [ ] Compound words spaced appropriately
