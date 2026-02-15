# Neural-Net-RS Explainer Video

Video explainer for the [neural-net-rs](https://github.com/sw-ml-study/neural-net-rs) neural network training platform.

## TTS Generation

**Always use the generate-tts.sh script:**

```bash
cd work
./generate-tts.sh
```

The script:
1. Scans `work/scripts/*.txt` for narration text files
2. Generates audio to `work/audio/` using VoxCPM
3. Skips files that already have audio
4. Verifies output with whisper

**Do NOT manually call client.py** - the script encapsulates the correct reference file and prompt text.

## Project Structure

```
neural-net-rs/
├── assets/
│   ├── svg/           # SVG slides (00-title through 99b-epilog)
│   └── images/        # Title background, etc.
├── work/
│   ├── scripts/       # Narration text files (add files here)
│   ├── audio/         # Generated TTS audio (auto-generated)
│   ├── clips/         # Video clips (OBS recordings, VHS demos)
│   ├── stills/        # PNG renders from SVG
│   ├── preview/       # Preview assembly workspace
│   └── generate-tts.sh  # TTS generation script
├── tts/
│   ├── .venv/         # Python venv for gradio_client
│   └── client.py      # VoxCPM client (called by generate-tts.sh)
└── README.md
```

## Content Sections

| Section | SVG | Script | Content |
|---------|-----|--------|---------|
| 00 | title-overlay | - | Title card |
| 01 | hook | hook | Introduction hook |
| 02 | overview | overview | Platform overview |
| 03 | logic-gates | logic-gates | AND, OR, XOR gates |
| 04 | scaling | scaling | Parity3 scaling |
| 05 | multiclass | multiclass | Quadrant classification |
| 06 | arithmetic | arithmetic | Binary adder |
| 07 | iris | iris | Iris dataset |
| 08 | patterns | patterns | Pattern recognition |
| 09 | cli-intro | cli-intro | CLI introduction |
| 10 | - | cli-demo (a,b,c) | CLI demo with VHS |
| 11 | webui-intro | webui-intro | Web UI introduction |
| 12 | - | and-demo | AND gate web demo |
| 13 | - | or-demo | OR gate web demo |
| 14 | xor-intro | xor-intro | XOR challenge explanation |
| 15 | - | xor-demo | XOR tuning demo |
| 16 | parity3-intro | parity3-intro | PARITY3 explanation |
| 17 | - | parity3-demo | PARITY3 3-attempt demo |
| 99 | cta | cta | Call to action |
| 99b | epilog | - | Epilog (music only) |

## Music

- Title and epilog: `reference/music/When You're Not Looking - Nathan Moore.mp3`
- 7s intro, 7s epilog extension
