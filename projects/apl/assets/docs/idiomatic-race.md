# Idiomatic APL Horse Race

A compact horse race simulation in GNU APL, inspired by programs from the APL\360 era (ca. 1972).

## Source Code

```apl
⍝ Idiomatic APL Horse Race

HORSES←'LUCKY  ' 'THUNDER' 'SHADOW ' 'COMET  ' 'BLAZE  '

∇ SHOW;I
  I←1
N:⎕←(I⊃HORSES),'│',((I⊃POS)⍴'░'),'▓'
  I←I+1
  →N×⍳I≤5
∇

∇ RACE;POS;_
  POS←5⍴0
  ⎕←'THE RACE IS ON!'
L:_←⎕DL 0.3
  POS←POS+?5⍴3
  SHOW
  ⎕←''
  →L×⍳~∨/POS≥15
  ⎕←'WINNER: ',(⊃(POS=⌈/POS)/⍳5)⊃HORSES
∇

RACE
)OFF
```

## Line-by-Line Explanation

### Global Setup

| Line | Code | Explanation |
|------|------|-------------|
| 1 | `⍝ Idiomatic APL Horse Race` | Comment (⍝ is the comment symbol) |
| 3 | `HORSES←'LUCKY  ' 'THUNDER' ...` | Create a vector of 5 horse names (padded to 7 chars each) |

### SHOW Function

| Line | Code | Explanation |
|------|------|-------------|
| 5 | `∇ SHOW;I` | Define function SHOW with local variable I |
| 6 | `I←1` | Initialize loop counter to 1 |
| 7 | `N:⎕←(I⊃HORSES),'│',((I⊃POS)⍴'░'),'▓'` | Label N: Pick Ith horse name, concatenate with bar, repeat ░ by position, add ▓ marker. Output via ⎕← |
| 8 | `I←I+1` | Increment counter |
| 9 | `→N×⍳I≤5` | **Classic idiom**: If I≤5, branch to N; otherwise continue. `⍳1` gives `1` (the label), `⍳0` gives empty (no branch) |
| 10 | `∇` | End function definition |

### RACE Function

| Line | Code | Explanation |
|------|------|-------------|
| 12 | `∇ RACE;POS;_` | Define RACE with local variables POS and _ (dummy for discarding results) |
| 13 | `POS←5⍴0` | Create vector of 5 zeros (starting positions) |
| 14 | `⎕←'THE RACE IS ON!'` | Print race start message |
| 15 | `L:_←⎕DL 0.3` | Label L: Delay 0.3 seconds (⎕DL = quad delay) |
| 16 | `POS←POS+?5⍴3` | Add random 1-3 to each position (?3 = random 1 to 3) |
| 17 | `SHOW` | Display current positions |
| 18 | `⎕←''` | Print blank line |
| 19 | `→L×⍳~∨/POS≥15` | **Classic idiom**: If NO horse ≥15, branch to L. `∨/` = or-reduce, `~` = not |
| 20 | `⎕←'WINNER: ',(⊃(POS=⌈/POS)/⍳5)⊃HORSES` | Find index of max position, pick that horse name |
| 21 | `∇` | End function definition |

### Execution

| Line | Code | Explanation |
|------|------|-------------|
| 23 | `RACE` | Call the RACE function |
| 24 | `)OFF` | Exit APL interpreter |

## Key APL Idioms

### Conditional Branch: `→LABEL×⍳condition`
- If condition is true (1): `⍳1` → `1`, so `→LABEL×1` → `→LABEL` (branch)
- If condition is false (0): `⍳0` → `⍬` (empty), so `→LABEL×⍬` → `→⍬` (no branch, continue)

### Random Numbers: `?N`
- `?3` returns random integer from 1 to 3
- `?5⍴3` returns 5 random integers, each 1 to 3

### Pick from Vector: `I⊃VECTOR`
- Selects the Ith element from VECTOR (1-indexed)

### Replicate: `N⍴CHAR`
- Repeats CHAR N times: `5⍴'░'` → `'░░░░░'`

### Or-Reduce: `∨/VECTOR`
- Returns 1 if any element is true: `∨/0 0 1 0 0` → `1`

### Max-Reduce: `⌈/VECTOR`
- Returns maximum value: `⌈/3 7 2 9 4` → `9`

## Running

```bash
timeout 30 apl --script -f ~/idiomatic-race.apl
```
