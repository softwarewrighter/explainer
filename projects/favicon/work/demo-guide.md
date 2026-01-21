# Favicon Demo Recording Guide

## Overview
Record OBS screen captures demonstrating the favicon generator CLI tool.

## Recording Setup
- Resolution: 1920x1080
- Clean terminal with large font
- Dark terminal background recommended

---

## Demo Sequences to Record

### Demo 1: Text Favicon
Generate favicon from text characters.

```bash
favicon --text "AB"              # Two letters
favicon --text "X" --png         # Single letter as PNG
favicon -t "SW" -o initials.ico  # With custom output path
```

**What to capture:**
1. Terminal showing the command
2. Generated file
3. Quick preview (open in Finder or viewer)

---

### Demo 2: Unicode Symbol by Alias
Generate favicon using symbol aliases.

```bash
favicon --unicode rocket         # Rocket emoji
favicon --unicode coffee         # Coffee cup
favicon --unicode wrench         # Wrench tool
favicon --unicode star           # Star
favicon -u heart -o heart.ico    # Heart with output path
```

**What to capture:**
1. Command with alias
2. Generated favicon

---

### Demo 3: Unicode by Code Point
Generate favicon using Unicode code points.

```bash
favicon --unicode U+1F600        # Grinning face
favicon --unicode 2764           # Red heart
favicon -u U+1F680               # Rocket
```

---

### Demo 4: Custom Colors
Show foreground/background color options.

```bash
favicon -t "A" -f "#FFFFFF" -b "#0066CC"    # White on blue
favicon -t "X" -f red -b black              # Red on black
favicon -u star -b transparent              # Transparent background
favicon -u fire -T                          # Shorthand transparent
```

---

### Demo 5: Rotation
Show rotation options.

```bash
favicon -u wrench -r 45          # Rotate 45 degrees clockwise
favicon -u wrench -R             # Rotate 90 degrees counter-clockwise
```

---

### Demo 6: Animated GIF (Optional)
Show animated rotation feature.

```bash
favicon -u gear --animated -r 15   # Spinning gear
favicon -u star --animated -r 30   # Rotating star
```

---

### Demo 7: List Symbols (Optional)
Show the available symbols.

```bash
favicon --list-symbols | head -30
```

---

## File Naming Convention
Save recordings to: `assets/videos/`
- `demo-text.mp4`
- `demo-unicode.mp4`
- `demo-colors.mp4`
- `demo-rotation.mp4`
- `demo-animated.mp4`

---

## Quick Reference

| Option | Description |
|--------|-------------|
| `-t, --text` | Text to render |
| `-u, --unicode` | Symbol alias or code point |
| `-o, --output-path` | Output file (default: ./favicon.ico) |
| `-f, --foreground` | Foreground color |
| `-b, --background` | Background color |
| `-T, --transparent` | Transparent background |
| `-r, --rotate-clock-wise` | Rotate CW (degrees) |
| `-R, --rotate-counter-clock-wise` | Rotate CCW (degrees) |
| `-a, --animated` | Generate animated GIF |
| `--png` | Output as PNG |
| `--list-symbols` | Show available symbol aliases |
