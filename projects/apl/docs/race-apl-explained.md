# APL Horse Race Program Explained

This document explains the APL horse race simulation shown in `race.apl.png`.

## Historical Context

This program runs on **GNU APL** on Arch Linux, but recreates the spirit of programs that ran on **APL\360** in the 1970s.

APL\360 was IBM's original APL implementation, released in 1966. It ran on IBM System/360 mainframes and was accessed via terminals like the IBM 2741 (a modified Selectric typewriter with the APL typeball). Programs like this horse race were popular demonstrations of APL's interactive, array-oriented nature.

**Key differences from the 1970s original:**
- Unicode characters (`░▓`) replace the original APL overstrike graphics or simple ASCII
- GNU APL runs locally; APL\360 was a time-sharing system
- The core APL syntax and semantics remain remarkably unchanged after 50+ years

## Overview

The program simulates a text-based horse race with 5 horses. Each round, horses advance random distances until one crosses the finish line. The race displays progress using ASCII art and announces a winner.

## Program Structure

The program consists of two functions:
1. `SHOWHORSES` - Displays the current position of all horses
2. `RACE` - Main game loop that runs the simulation

---

## Function 1: SHOWHORSES

```apl
∇ SHOWHORSES;I
  I←1
  NEXT:⍞←(I⊃HORSES),' ',((I⊃POS)⍴'░'),'▓'
  ⍞←DL 0.3
  I←I+1
  →NEXT×⍳I≤5
∇
```

### Line-by-Line Breakdown

| Line | Code | Explanation |
|------|------|-------------|
| 1 | `∇ SHOWHORSES;I` | Define function `SHOWHORSES` with local variable `I` |
| 2 | `I←1` | Initialize counter `I` to 1 |
| 3 | `NEXT:⍞←(I⊃HORSES),' ',((I⊃POS)⍴'░'),'▓'` | Label `NEXT`. Print: horse name, space, progress bar, horse marker |
| 4 | `⍞←DL 0.3` | Delay 0.3 seconds (visual pacing) |
| 5 | `I←I+1` | Increment counter |
| 6 | `→NEXT×⍳I≤5` | If `I≤5`, branch to `NEXT`; otherwise exit |

### Key APL Operations in Line 3

- `I⊃HORSES` — Select the I-th element from the `HORSES` array (pick horse name)
- `I⊃POS` — Select the I-th element from `POS` (get horse's current position)
- `N⍴'░'` — Reshape: create a string of N `░` characters (the track behind the horse)
- `'▓'` — The horse marker character
- `,` — Concatenate strings together

**Example output for a horse at position 7:**
```
LUCKY   ░░░░░░░▓
```

### Branch Logic (Line 6)

```apl
→NEXT×⍳I≤5
```

This is a classic APL conditional branch:
- `I≤5` — Returns 1 (true) or 0 (false)
- `⍳1` returns `1`, while `⍳0` returns empty vector
- `NEXT×1` = line number of `NEXT`; `NEXT×⍬` = nothing (fall through)
- `→` branches to that line, or exits if empty

---

## Function 2: RACE

```apl
∇ RACE;HORSES;POS;FINISH;ROUND;_
  HORSES←'LUCKY' 'THUNDER' 'SHADOW' 'COMET' 'BLAZE'
  POS←5⍴0
  FINISH←15
  ROUND←0
  ⍞←DL 0.
  _←'▓'
  ⍞←DL 0.5
  _←'            THE RACE IS ON!'
  ⍞←DL 1
  LOOP:ROUND←ROUND+1
  ⍞←'.'
  ⍞←'... ROUND ',⍕ROUND,' ...'
  ⍞←DL 0.3
  POS←POS+?5⍴3
  SHOWHORSES
  ⍞←DL 0.5
  →DONE×⍳∨/POS≥FINISH
  →LOOP
  DONE:⍞←'.'
  ⍞←DL 0.5
  ⍞←' WINNER: ',((POS=⌈/POS)/HORSES),''
  ⍞←DL 0.3
∇
```

### Line-by-Line Breakdown

| Line | Code | Explanation |
|------|------|-------------|
| 1 | `∇ RACE;HORSES;POS;FINISH;ROUND;_` | Define `RACE` with local variables |
| 2 | `HORSES←'LUCKY' 'THUNDER' 'SHADOW' 'COMET' 'BLAZE'` | Array of 5 horse names |
| 3 | `POS←5⍴0` | Initialize positions: 5 zeros `0 0 0 0 0` |
| 4 | `FINISH←15` | Finish line at position 15 |
| 5 | `ROUND←0` | Start at round 0 |
| 6-9 | Display setup | Show intro message "THE RACE IS ON!" |
| 10 | `LOOP:ROUND←ROUND+1` | Label `LOOP`. Increment round counter |
| 11-12 | `⍞←'... ROUND ',⍕ROUND,' ...'` | Print round number (⍕ converts number to string) |
| 13 | `⍞←DL 0.3` | Delay for effect |
| 14 | `POS←POS+?5⍴3` | **Key line**: Add random 1-3 to each position |
| 15 | `SHOWHORSES` | Call display function |
| 16 | `⍞←DL 0.5` | Pause between rounds |
| 17 | `→DONE×⍳∨/POS≥FINISH` | If ANY horse crossed finish, go to DONE |
| 18 | `→LOOP` | Otherwise, continue racing |
| 19-22 | `DONE:` block | Announce winner |

### Key APL Operations

#### Random Movement (Line 14)
```apl
POS←POS+?5⍴3
```

- `5⍴3` — Create vector `3 3 3 3 3`
- `?5⍴3` — Roll dice: random integers 1-3 for each horse
- `POS+...` — Add to current positions (vectorized operation)

**Example:**
```
POS:     2 5 3 7 4
?5⍴3:    1 3 2 1 2
Result:  3 8 5 8 6
```

#### Win Condition (Line 17)
```apl
→DONE×⍳∨/POS≥FINISH
```

- `POS≥FINISH` — Boolean mask: which horses crossed finish (e.g., `0 1 0 1 0`)
- `∨/` — OR-reduce: 1 if ANY horse finished, 0 otherwise
- Same branch pattern as `SHOWHORSES`

#### Finding the Winner (Line 21)
```apl
⍞←' WINNER: ',((POS=⌈/POS)/HORSES),''
```

- `⌈/POS` — Maximum position (reduce with max)
- `POS=⌈/POS` — Boolean mask: which horse(s) have max position
- `(...)/HORSES` — Compress/filter: select winning horse name(s)

**Example:**
```
POS:         12 16 14 15 16
⌈/POS:       16
POS=⌈/POS:   0 1 0 0 1  (THUNDER and BLAZE tied)
Result:      'THUNDER' 'BLAZE'
```

---

## Execution

```apl
RACE
)OFF
```

- `RACE` — Run the main function
- `)OFF` — System command to exit APL

---

## Sample Output

```
            THE RACE IS ON!
... ROUND 1 ...
LUCKY   ░░▓
THUNDER ░░░▓
SHADOW  ░▓
COMET   ░░░▓
BLAZE   ░░▓

... ROUND 2 ...
LUCKY   ░░░░▓
THUNDER ░░░░░░▓
SHADOW  ░░░▓
COMET   ░░░░░▓
BLAZE   ░░░░░▓

... (rounds continue) ...

 WINNER: THUNDER
```

---

## Key APL Concepts Demonstrated

| Concept | Symbol | Example in Code |
|---------|--------|-----------------|
| Assignment | `←` | `I←1` |
| Pick/Index | `⊃` | `I⊃HORSES` |
| Reshape | `⍴` | `5⍴0`, `N⍴'░'` |
| Roll (random) | `?` | `?5⍴3` |
| Reduce | `/` | `∨/`, `⌈/` |
| Compress/Filter | `/` | `mask/HORSES` |
| Branch | `→` | `→NEXT`, `→DONE` |
| Quad output | `⍞` | `⍞←'text'` |
| Format (stringify) | `⍕` | `⍕ROUND` |
| Max | `⌈` | `⌈/POS` |
| Or | `∨` | `∨/` |
| Compare | `≥` `=` `≤` | `POS≥FINISH` |

---

## Design Notes

1. **No explicit loops**: APL operates on entire arrays at once (`POS←POS+?5⍴3` updates all 5 horses in one statement)

2. **Conditional branches**: The `→LABEL×⍳condition` pattern is idiomatic APL for conditional jumps

3. **Text-based visualization**: Uses Unicode block characters (`░▓`) to create a progress bar effect

4. **Randomness**: The `?` (roll) function provides game unpredictability

5. **Implicit iteration**: `SHOWHORSES` loops with a counter, but the position updates are vectorized

---

## GNU APL vs APL\360 Notes

### What's the Same

The core language is remarkably preserved:
- Function definition syntax (`∇...∇`)
- Local variables after semicolon
- Branch with `→` and labels
- All primitive functions (`⍴`, `⊃`, `?`, `⌈`, etc.)
- Quad output `⍞`
- System command `)OFF`

### Adaptations for Modern Systems

| APL\360 (1970s) | GNU APL (today) | Notes |
|-----------------|-----------------|-------|
| Overstrike chars | Unicode `░▓` | Terminals couldn't display graphics; overstrikes created compound symbols |
| 2741 terminal | xterm/konsole | Any Unicode-capable terminal works |
| Time-sharing | Local execution | No login, immediate workspace |
| `⎕DL` | `⎕DL` | Delay function preserved in GNU APL |

### Running This Program

On Arch Linux with GNU APL installed:

```bash
# Start GNU APL
apl

# Load and run the program
)LOAD race
RACE
```

Or execute directly:
```bash
apl -f race.apl
```

### The APL\360 Experience

In the 1970s, running this program meant:
1. Sitting at an IBM 2741 terminal (essentially a modified electric typewriter)
2. Dialing into the mainframe via modem
3. Loading your workspace from disk or tape
4. Watching the race print character by character on paper (not a screen)

The `⎕DL 0.3` delays would have been essential to create readable output on the slow printing terminal, where characters appeared at roughly 15 characters per second
