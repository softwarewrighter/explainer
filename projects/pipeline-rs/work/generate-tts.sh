#!/bin/bash
set -e

PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/pipeline-rs"
TTS_DIR="$PROJECT/tts"
SCRIPTS_DIR="$PROJECT/work/scripts"
AUDIO_DIR="$PROJECT/work/audio"
REF="/Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.wav"
PROMPT_TEXT="In this session, I'm going to write a small command line tool and explain the decision making process as I go. I'll begin with a basic skeleton, argument parsing, a configuration loader, and a minimal main function. Once everything compiles, I'll run it with a few sample inputs to confirm the behavior. After that, I'll be fine the internal design. I'll reorganize the functions, extract shared logic, and add error messages that actually help the user understand what went wrong. None of this is complicated, but it's the kind of work that separates a rough prototype from a tool someone can rely on. As we move forward, I'll highlight why I chose certain patterns, some decisions, optimize clarity, while others optimize performance or extensibility. The important thing is to understand the trade-offs well enough that the code feels intentional instead of accidental."
WHISPER_MODEL="$HOME/.local/share/whisper-cpp/models/ggml-medium.en.bin"

cd "$TTS_DIR"
source .venv/bin/activate

mkdir -p "$AUDIO_DIR"

# Process each script file in order
for script in $(ls "$SCRIPTS_DIR"/*.txt | sort); do
    base=$(basename "$script" .txt)
    raw_out="$AUDIO_DIR/${base}-raw.wav"

    # Skip if already generated and verified
    if [ -f "$raw_out" ]; then
        echo "SKIP: $base (already exists)"
        continue
    fi

    text=$(cat "$script" | tr -d '\n')
    echo "=== TTS: $base ==="
    echo "  Text: $text"

    python client.py \
        --server http://curiosity:7860 \
        --reference "$REF" \
        --prompt-text "$PROMPT_TEXT" \
        --text "$text" \
        --output "$raw_out" \
        --steps 15

    # Verify with whisper
    echo "  Verifying with whisper..."
    whisper_out=$(whisper-cli -m "$WHISPER_MODEL" -f "$raw_out" --no-timestamps 2>/dev/null)
    echo "  Whisper: $whisper_out"
    echo ""
done

echo "=== ALL TTS COMPLETE ==="
