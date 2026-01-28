# Idiomatic APL Horse Race

A compact, idiomatic version of the horse race program in 15 lines.

## The Complete Program

```apl
#!/usr/bin/apl -f
⍝ Idiomatic APL Horse Race - Compact Version

HORSES←'LUCKY  ' 'THUNDER' 'SHADOW ' 'COMET  ' 'BLAZE  '

∇ R←SHOW POS
  R←↑HORSES,¨'|',¨({⍵⍴'░'}¨POS),¨'▓'
∇

∇ RACE;POS
  POS←5⍴0 ⋄ ⎕←'THE RACE IS ON!'
  L:⎕DL 0.3 ⋄ POS←POS+?5⍴3 ⋄ ⎕←SHOW POS
  →L×⍳~∨/POS≥15
  ⎕←'WINNER: ',⊃(POS=⌈/POS)/HORSES
∇

RACE
)OFF
```

## Line-by-Line Explanation

### Line 1: Shebang
```apl
#!/usr/bin/apl -f
```
Unix shebang for direct execution. The `-f` flag runs the file as a script.

### Line 2: Comment
```apl
⍝ Idiomatic APL Horse Race - Compact Version
```
`⍝` begins a comment (lamp symbol - "illuminates" the code).

### Line 4: Global Data
```apl
HORSES←'LUCKY  ' 'THUNDER' 'SHADOW ' 'COMET  ' 'BLAZE  '
```
Vector of 5 horse names, padded to 7 characters for aligned output.

### Lines 6-8: SHOW Function
```apl
∇ R←SHOW POS
  R←↑HORSES,¨'|',¨({⍵⍴'░'}¨POS),¨'▓'
∇
```

**Header**: `R←SHOW POS` - takes positions, returns display matrix.

**Body breakdown** (read right to left):

| Fragment | Result for POS=`3 5 2` |
|----------|------------------------|
| `{⍵⍴'░'}¨POS` | `'░░░' '░░░░░' '░░'` — reshape '░' by each position |
| `(...),¨'▓'` | `'░░░▓' '░░░░░▓' '░░▓'` — append horse marker |
| `'|',¨(...)` | `'|░░░▓' '|░░░░░▓' '|░░▓'` — prepend separator |
| `HORSES,¨(...)` | `'LUCKY  |░░░▓' ...` — prepend names |
| `↑(...)` | Mix vector of strings into aligned matrix |

**Key idiom**: `,¨` (catenate-each) threads concatenation across parallel arrays.

### Lines 10-15: RACE Function
```apl
∇ RACE;POS
  POS←5⍴0 ⋄ ⎕←'THE RACE IS ON!'
  L:⎕DL 0.3 ⋄ POS←POS+?5⍴3 ⋄ ⎕←SHOW POS
  →L×⍳~∨/POS≥15
  ⎕←'WINNER: ',⊃(POS=⌈/POS)/HORSES
∇
```

**Line 11**: Initialize and announce
```apl
POS←5⍴0 ⋄ ⎕←'THE RACE IS ON!'
```
- `5⍴0` — Five zeros: `0 0 0 0 0`
- `⋄` — Statement separator (like `;` in C)
- `⎕←` — Print to stdout

**Line 12**: Main loop (one line!)
```apl
L:⎕DL 0.3 ⋄ POS←POS+?5⍴3 ⋄ ⎕←SHOW POS
```
- `L:` — Label for branch target
- `⎕DL 0.3` — Delay 0.3 seconds
- `?5⍴3` — Roll 5 dice, each 1-3
- `POS←POS+...` — Add to positions (vectorized)
- `⎕←SHOW POS` — Display current state

**Line 13**: Continue condition
```apl
→L×⍳~∨/POS≥15
```
Read right to left:
- `POS≥15` — Boolean: which horses crossed finish
- `∨/` — OR-reduce: 1 if any finished
- `~` — NOT: 1 if race continues, 0 if done
- `⍳~...` — Index: `1` if continuing, empty if done
- `L×...` — Multiply label by that (L or 0)
- `→` — Branch: to L, or fall through if empty

**Line 14**: Announce winner
```apl
⎕←'WINNER: ',⊃(POS=⌈/POS)/HORSES
```
- `⌈/POS` — Maximum position
- `POS=⌈/POS` — Boolean mask of winner(s)
- `(...)/HORSES` — Compress: select winning name(s)
- `⊃` — First: pick one if tie

### Lines 17-18: Execution
```apl
RACE
)OFF
```
Run the race, then exit APL.

## Comparison: Original vs Idiomatic

| Aspect | Original | Idiomatic |
|--------|----------|-----------|
| Lines of code | ~35 | 15 |
| SHOWHORSES | Explicit loop with counter | Single expression with each (`¨`) |
| Loop body | Multiple statements | One line with `⋄` |
| Display | Character-by-character | Matrix output |
| Delays | Many | One per round |

## Key Idioms Used

1. **Each operator (`¨`)** — Apply function to each element
2. **Statement separator (`⋄`)** — Multiple statements per line
3. **Mix (`↑`)** — Convert nested vector to matrix
4. **Dfn (`{⍵⍴'░'}`)** — Inline anonymous function
5. **Conditional branch** — `→L×⍳condition`

## Running

```bash
# On Arch Linux with GNU APL
chmod +x idiomatic-race.apl
./idiomatic-race.apl

# Or within APL
apl
)LOAD idiomatic-race
RACE
```

## Expected Output

```
THE RACE IS ON!
LUCKY  |░░▓
THUNDER|░▓
SHADOW |░░░▓
COMET  |░░▓
BLAZE  |░▓

LUCKY  |░░░░░▓
THUNDER|░░░░▓
SHADOW |░░░░░▓
COMET  |░░░░▓
BLAZE  |░░░▓

... (continues until finish) ...

WINNER: SHADOW
```
