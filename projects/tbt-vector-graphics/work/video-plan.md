# TBT Vector Graphics Games - Video Plan

## Video Structure

| # | Segment | Type | Duration | Description |
|---|---------|------|----------|-------------|
| 00 | title | Title + music | 5s | Title card with arcade background |
| 01 | hook | SVG + narration | ~12s | "Before pixels, vectors" intro |
| 02 | history | SVG + narration | ~15s | IBM 2250, mainframes, military origins |
| 03 | white-vectors | SVG + narration | ~12s | Pong, Lunar Lander, Asteroids |
| 04 | color-vectors | SVG + narration | ~12s | BattleZone green, Tempest multicolor |
| 05 | project | SVG + narration | ~12s | Vectorcade Rust/WASM architecture |
| 99 | cta | SVG + narration | ~10s | Links, try it yourself |
| 99b | epilog | Frame + music | 12s | Standard epilog with fade |

**Total: ~90 seconds** (without demo footage)

Note: Demo footage segments can be added later when vectorcade repos are ready.

---

## Slides and Scripts

### 01-hook.svg
**Layout:** Single statement, vector-style text
- Headline: "Before Pixels"
- Subtitle: "There Were Vectors"
- Subtext: Lines drawn point to point, no grid, no fill

**01-hook.txt (TTS):**
```
Before pixels dominated screens, there were vectors. Lines drawn directly from point to point, with no grid and no fill. Just pure geometry rendered in glowing phosphor.
```
(156 chars)

---

### 02-history.svg
**Layout:** Two-box layout
- Headline: "Military Origins"
- Box 1 (cyan): "NORAD Era" — radar displays, real time tracking
- Box 2 (green): "IBM 2250" — quarter million dollars, mainframe graphics

**02-history.txt (TTS):**
```
Vector displays started in military systems. NORAD used them for radar tracking. The IBM twenty two fifty cost a quarter million dollars and connected to mainframes as a dedicated graphics terminal.
```
(198 chars)

---

### 03-white-vectors.svg
**Layout:** Three-box layout (game evolution)
- Headline: "White on Black"
- Box 1 (white): "Pong" — two paddles, one ball, pure vectors
- Box 2 (white): "Lunar Lander" — thrust and gravity, fuel management
- Box 3 (white): "Asteroids" — rotate, thrust, shoot, wrap around

**03-white-vectors.txt (TTS):**
```
The first vector games drew white lines on black screens. Pong showed two paddles and a ball. Lunar Lander added gravity and fuel. Asteroids introduced rotation, thrust, and screen wrapping.
```
(191 chars)

---

### 04-color-vectors.svg
**Layout:** Two-box layout
- Headline: "Adding Color and Depth"
- Box 1 (green): "BattleZone" — green wireframe tanks, pseudo three D
- Box 2 (multicolor): "Tempest" — tubes, colors, true depth illusion

**04-color-vectors.txt (TTS):**
```
Color changed everything. BattleZone rendered green wireframe tanks in pseudo three D. Tempest pushed further with multicolored tubes creating a true depth illusion. Each game built on the last.
```
(196 chars)

---

### 05-project.svg
**Layout:** Architecture diagram style
- Headline: "Vectorcade"
- Subtitle: "Modern Recreation"
- Boxes showing: Games, Shared, Fonts, Renderer, Web
- Tech labels: Rust, WASM, GPU

**05-project.txt (TTS):**
```
Vectorcade recreates these mechanics in Rust and WebAssembly. The architecture separates game logic, vector fonts, GPU rendering, and the web frontend into distinct modules.
```
(173 chars)

---

### 99-cta.svg
**Layout:** Standard CTA
- Headline: "Explore the Code"
- Box 1 (green): "GitHub" — five repositories, all open source
- Box 2 (yellow): "Coming Soon" — playable demos in browser

**99-cta.txt (TTS):**
```
The source code is on GitHub across five repositories. Playable browser demos are coming soon. Links are in the description. This has been a Throwback Thursday project.
```
(169 chars)

---

## Production Checklist

- [ ] Create 6 SVG slides (01-05, 99)
- [ ] Run /style-check on all SVGs
- [ ] Generate TTS for 6 scripts
- [ ] Whisper verify each audio file
- [ ] Render SVGs to PNG
- [ ] Create base videos from PNGs
- [ ] Mux audio with video
- [ ] Normalize all clips
- [ ] Create title clip (00)
- [ ] Create epilog clips (99b, 99c)
- [ ] Concatenate full video
- [ ] Update preview/index.html
