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
