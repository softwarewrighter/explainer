# VoxCPM Voice Cloning for engram-poc

## Server

VoxCPM runs on `http://curiosity:7860/`

## Reference Audio

- File: `../work/reference/mike-ref-17s.wav` (17 seconds)
- Transcript: "In this session, I'm going to write a small command line tool and explain the decision making process as I go. I'll begin with a basic skeleton, argument parsing, a configuration loader, and a minimal main function."

## Generate TTS

```bash
cd /Users/mike/github/softwarewrighter/explainer/projects/engram-poc

# Hook narration
python tts/client.py --server http://curiosity:7860 \
    --reference work/reference/mike-ref-17s.wav \
    --prompt-text "In this session, I'm going to write a small command line tool and explain the decision making process as I go. I'll begin with a basic skeleton, argument parsing, a configuration loader, and a minimal main function." \
    --text "$(cat work/scripts/01-hook.txt)" \
    --output work/audio/01-hook.wav

# Demo narration
python tts/client.py --server http://curiosity:7860 \
    --reference work/reference/mike-ref-17s.wav \
    --prompt-text "In this session, I'm going to write a small command line tool and explain the decision making process as I go. I'll begin with a basic skeleton, argument parsing, a configuration loader, and a minimal main function." \
    --text "$(cat work/scripts/02-demo.txt)" \
    --output work/audio/02-demo.wav

# CTA narration
python tts/client.py --server http://curiosity:7860 \
    --reference work/reference/mike-ref-17s.wav \
    --prompt-text "In this session, I'm going to write a small command line tool and explain the decision making process as I go. I'll begin with a basic skeleton, argument parsing, a configuration loader, and a minimal main function." \
    --text "$(cat work/scripts/99-cta.txt)" \
    --output work/audio/99-cta.wav
```

## Parameters

| Parameter | Value |
|-----------|-------|
| `--cfg` | 2.0 (default) |
| `--steps` | 15 (default), 25 for higher quality |
