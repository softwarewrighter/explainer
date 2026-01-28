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
