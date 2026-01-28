∇ SHOWHORSES;I
  I←1
NEXT:⎕←(I⊃HORSES),' │',(((I⊃POS)⌊20)⍴'▓'),'◄'
  _←⎕DL 0.3
  I←I+1
  →NEXT×⍳I≤5
∇

∇ RACE;HORSES;POS;FINISH;ROUND;_
  HORSES←'LUCKY  ' 'THUNDER' 'SHADOW ' 'COMET  ' 'BLAZE  '
  POS←5⍴0
  FINISH←15
  ROUND←0
  ⎕←'══════════════════════════════════════════'
  _←⎕DL 0.5
  ⎕←'           THE RACE IS ON!'
  _←⎕DL 0.5
  ⎕←'══════════════════════════════════════════'
  _←⎕DL 1
LOOP:ROUND←ROUND+1
  ⎕←''
  ⎕←'--- ROUND ',(⍕ROUND),' ---'
  _←⎕DL 0.3
  POS←POS+?5⍴3
  SHOWHORSES
  _←⎕DL 0.5
  →DONE×⍳∨/POS≥FINISH
  →LOOP
DONE:⎕←''
  _←⎕DL 0.5
  ⎕←'══════════════════════════════════════════'
  _←⎕DL 0.3
  ⎕←'WINNER: ',((⊃(POS=⌈/POS)/⍳5)⊃HORSES),'!'
  _←⎕DL 0.3
  ⎕←'══════════════════════════════════════════'
∇
RACE
)OFF
