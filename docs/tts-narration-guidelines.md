# TTS Narration Guidelines

Guidelines for writing narration scripts that produce clean, accurate TTS audio.

## Character Restrictions

Only use these characters in narration scripts:
- Letters: A-Z, a-z
- Numbers: 0-9
- Punctuation: period (.), comma (,)

**Forbidden characters:**
- Apostrophes (')
- Hyphens (-)
- Dashes (— –)
- Exclamation points (!)
- Question marks (?)
- Semicolons (;)
- Colons (:)
- Quotes (" ')
- Slashes (/)
- At symbols (@)
- Dollar signs ($)

## Term Replacements

Replace acronyms and technical terms with spoken equivalents:

| Original | Replace With |
|----------|--------------|
| LLM | Language Model |
| LLMs | Language Models |
| RLM | Recursive Language Model |
| WASM | Web Assembly |
| wasm | Web Assembly |
| wasm_intent | Web Assembly intent |
| API | A P I |
| CLI | C L I |
| IP | I P |
| URL | U R L |
| DSL | D S L |
| AI | A I |
| TTS | T T S |
| 3D | three D |
| $50,000 | fifty thousand dollars |
| $297 | two ninety seven |
| /ralph-loop | slash ralph loop |
| /cancel | slash cancel |
| PROMPT.md | prompt dot M D |
| CLAUDE.md | claude dot M D |
| README.md | read me dot M D |
| .json | dot json |
| .rs | dot R S |
| GitHub | GitHub |
| demos | demonstrations |
| demo | demonstration |

## Avoid All Caps

Never use all caps words. They may be pronounced incorrectly.

| Wrong | Correct |
|-------|---------|
| AI coding | A I coding |
| The LLM processed | The Language Model processed |
| YC teams | Y Combinator teams |
| RLM framework | Recursive Language Model framework |

## Number Formatting

**NEVER use digits in scripts.** Always use words, and prefer rounded approximations over exact values.

| Wrong | Correct |
|-------|---------|
| 65,660 lines | sixty thousand lines |
| 3.3 megabytes | over three megabytes |
| 6 iterations | six iterations |
| 0 to 6 tests | zero to six tests |
| 13 passing | thirteen passing |
| 100 lines | one hundred lines |
| 19,991 chars | about twenty thousand characters |
| 80% reduction | eighty percent reduction |

**Why approximations work better:**
- Exact numbers like "65,660" can cause TTS glitches
- Listeners cannot process exact figures anyway
- Approximations sound more natural when spoken
- Reduces risk of mispronunciation

**Examples:**
| Exact (avoid) | Approximate (prefer) |
|---------------|---------------------|
| 3,339,794 characters | over three million characters |
| 638,327 chars reduced | reduced to about six hundred thousand |
| 19,991 chars remaining | under twenty thousand characters left |

## Sentence Structure

- Use periods, not question marks, even for rhetorical questions
- Keep sentences short, around 10 to 20 words
- Avoid complex punctuation that might confuse TTS

## Technical Term Density

**Avoid clustering technical terms together.** Insert common words and phrases between technical terms to:
1. Make the narration easier to understand
2. Help VibeVoice pronounce terms correctly
3. Give listeners time to process each concept

### Bad: Too Many Tech Terms Together
```
The L4 LLM chunks the WASM CLI output into sub-LLM API calls.
```

### Good: Common Words Between Tech Terms
```
Level 4 takes the output and breaks it into smaller pieces. Each piece goes to a separate Language Model call.
```

### Guidelines for LLM-Generated Scripts

When generating narration scripts:
- **Spread technical terms apart** with regular English words
- **Explain rather than abbreviate** when possible
- **Prefer familiar phrases** over jargon
- **One technical concept per sentence** when possible
- **Use transition words** like "then", "next", "finally" to add breathing room
- **Avoid stacking** acronyms or technical nouns

### Example Rewrites

| Dense (avoid) | Readable (prefer) |
|---------------|-------------------|
| "L4 LLM sub-calls process chunks" | "Level 4 sends each chunk to a separate Language Model" |
| "CLI WASM API integration" | "The command line tool connects to the Web Assembly interface" |
| "RLM L1-L4 execution pipeline" | "The Recursive Language Model has four execution levels" |

## Max Length

Keep each script segment under 320 characters. Longer sequences sound more natural than concatenating many short clips. Since we verify with whisper, longer sequences that fail are easy to detect and fix.

Split into multiple files only when necessary, using suffixes like:
- 03-technique-a.txt
- 03-technique-b.txt

## Validation

After generating TTS, validate with whisper transcription:

```bash
whisper-cli -m ~/.whisper-models/ggml-base.en.bin audio.wav
```

Compare transcription to source script. If mismatches occur:
1. Check for forbidden characters
2. Use phonetic spellings
3. Regenerate TTS
4. Re-validate

## Words and Phrases to Avoid

### Problematic Phrases

| Avoid | Use Instead | Reason |
|-------|-------------|--------|
| "Demo" | "Demonstration" | Clearer pronunciation |
| "Demo one" | "First up" or "The first demonstration" | "Demo one" sounds like "GIMA" |
| "Demo two" | "Next" or "The second demonstration" | Similar pronunciation issue |
| "Demo three" | "Third" | Clearer |
| "Demo four" | "Finally" | Clearer |
| "So..." | (remove) | Filler, sounds unprofessional |
| "Basically..." | (remove) | Filler |
| "Actually..." | (remove) | Filler |
| "You know" | (remove) | Filler |
| "sub-LLM" | "sub Language Model" or "secondary model" | Avoid acronym clusters |

### Content References to Avoid

When demonstrations or content change, avoid references that lock you into specific examples:

| Avoid | Reason |
|-------|--------|
| "Three million characters" | Specific to War and Peace |
| "Family tree" | Specific to War and Peace |
| Specific character counts | May change between demonstrations |
| Specific file sizes | May change |

Use generic references instead: "large datasets", "complex data", "beyond context limits"

## VibeVoice Specific Issues

### Known Pronunciation Problems

- Compound words may be split incorrectly
- Some technical terms need phonetic spelling
- Rapid sequences of similar sounds can blur together

### Pacing

- Insert commas for natural pauses
- Short sentences give cleaner pacing
- Avoid run-on sentences

### Voice Cloning Notes

- Reference audio quality affects output
- Consistent speaking style in reference produces better results
- Avoid mixing formal and casual tone in same script

## Example Before and After

**Before (problematic):**
```
What if you could ship 6 repos overnight for under $300? Or complete a $50K contract for $297!
```

**After (clean):**
```
What if you could ship six repos overnight for under three hundred dollars. Or complete a fifty thousand dollar contract for two ninety seven.
```

**Before (specific reference problem):**
```
War and Peace is 3.2 megabytes, over five hundred thousand words.
```

**After (generic reference):**
```
The case file has over four hundred lines of evidence. Too complex for a single context window.
```

---

## Additional Rules

<!-- Add more rules below as discovered -->
