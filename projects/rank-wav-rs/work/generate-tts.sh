#!/bin/bash
set -e

PROJECT="/Users/mike/github/softwarewrighter/explainer/projects/rank-wav-rs"
TTS_DIR="$PROJECT/tts"
SCRIPTS_DIR="$PROJECT/work/scripts"
AUDIO_DIR="$PROJECT/work/audio"
REF="/Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.wav"
REF_TXT="/Users/mike/github/softwarewrighter/video-publishing/reference/voice/mike-medium-ref-1.txt"
PROMPT_TEXT="$(cat "$REF_TXT")"
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
        --server http://queenbee.local:7860 \
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
