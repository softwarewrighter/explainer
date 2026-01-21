#!/bin/bash
# Build OBS narrated clip by overlaying 65 narration audio files at specific timestamps
#
# The OBS recording has its audio stripped and replaced with narration clips
# positioned according to timestamps in work/scripts/narration-all.txt
#
# Per plan.md: "Narration timestamp 00:15 maps to OBS position 0:00"
# So we subtract 15 seconds from each timestamp to get OBS position.

set -e
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/common.sh"

# Allow override via environment variable for testing with trimmed video
OBS_SOURCE="${OBS_SOURCE_OVERRIDE:-/Users/mike/Movies/2026-01-07 22-22-53.mp4}"
NARRATION_FILE="$WORK/scripts/narration-all.txt"
OUTPUT="$CLIPS/03-67-obs-narrated.mp4"

# Verify source files exist
if [[ ! -f "$OBS_SOURCE" ]]; then
    echo "ERROR: OBS source not found: $OBS_SOURCE"
    exit 1
fi

if [[ ! -f "$NARRATION_FILE" ]]; then
    echo "ERROR: Narration file not found: $NARRATION_FILE"
    exit 1
fi

echo "=== Building OBS Narrated Clip ==="
echo "OBS Source: $OBS_SOURCE"
echo "Narration timestamps: $NARRATION_FILE"

# Parse timestamps from narration-all.txt
# Format: [MM:SS] Text...
# Extract timestamps and convert to milliseconds, applying 15s offset
declare -a TIMESTAMPS_MS
declare -a AUDIO_FILES

# Audio files are numbered 03-67 in sequence
AUDIO_NUM=3

while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Extract timestamp [MM:SS]
    if [[ "$line" =~ ^\[([0-9]+):([0-9]+)\] ]]; then
        MINUTES="${BASH_REMATCH[1]}"
        SECONDS="${BASH_REMATCH[2]}"

        # Convert to total seconds
        TOTAL_SECS=$((10#$MINUTES * 60 + 10#$SECONDS))

        # Apply 15 second offset (OBS starts at final video 00:15)
        OBS_SECS=$((TOTAL_SECS - 15))

        # Ensure non-negative
        if (( OBS_SECS < 0 )); then
            OBS_SECS=0
        fi

        # Convert to milliseconds for adelay filter
        MS=$((OBS_SECS * 1000))

        # Format audio number with leading zero if needed
        if (( AUDIO_NUM < 10 )); then
            AUDIO_NAME="0${AUDIO_NUM}"
        else
            AUDIO_NAME="${AUDIO_NUM}"
        fi

        # Find the audio file matching this number
        AUDIO_FILE=$(ls "$AUDIO"/${AUDIO_NAME}-*.wav 2>/dev/null | head -1)

        if [[ -f "$AUDIO_FILE" ]]; then
            TIMESTAMPS_MS+=("$MS")
            AUDIO_FILES+=("$AUDIO_FILE")
            echo "  [$MINUTES:$SECONDS] -> OBS ${OBS_SECS}s -> $(basename "$AUDIO_FILE")"
        else
            echo "  WARNING: No audio file for number $AUDIO_NAME"
        fi

        ((AUDIO_NUM++))
    fi
done < "$NARRATION_FILE"

NUM_AUDIO=${#AUDIO_FILES[@]}
echo ""
echo "Found $NUM_AUDIO narration clips to overlay"

if (( NUM_AUDIO == 0 )); then
    echo "ERROR: No audio files found"
    exit 1
fi

# Build ffmpeg command
# Input: OBS video (index 0) + all audio files (index 1 to N)
INPUTS="-i \"$OBS_SOURCE\""
FILTER_PARTS=""
AMIX_INPUTS=""

for i in "${!AUDIO_FILES[@]}"; do
    AUDIO_FILE="${AUDIO_FILES[$i]}"
    DELAY_MS="${TIMESTAMPS_MS[$i]}"
    INPUT_IDX=$((i + 1))

    INPUTS="$INPUTS -i \"$AUDIO_FILE\""

    # adelay filter: delay both channels by the same amount
    # Output label: [a$i]
    FILTER_PARTS="${FILTER_PARTS}[$INPUT_IDX:a]adelay=${DELAY_MS}|${DELAY_MS}[a$i];"
    AMIX_INPUTS="${AMIX_INPUTS}[a$i]"
done

# amix to combine all delayed audio tracks
FILTER_COMPLEX="${FILTER_PARTS}${AMIX_INPUTS}amix=inputs=${NUM_AUDIO}:duration=longest:dropout_transition=0[aout]"

echo ""
echo "Running ffmpeg to mix audio tracks..."
echo "(This may take a few minutes for 65 audio tracks)"

# Build and execute ffmpeg command
CMD="ffmpeg -y $INPUTS -filter_complex \"$FILTER_COMPLEX\" -map 0:v -map \"[aout]\" -c:v copy -c:a aac -b:a 192k \"$OUTPUT\""

echo ""
echo "Command preview (truncated):"
echo "${CMD:0:500}..."
echo ""

eval "$CMD"

# Verify output
if [[ -f "$OUTPUT" ]]; then
    DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT")
    echo ""
    echo "=== Success ==="
    echo "Output: $OUTPUT"
    echo "Duration: ${DURATION}s"

    # Check audio level
    $VID_VOLUME --input "$OUTPUT" --print-levels 2>&1 | grep -E "(Mean|Max)" || true
else
    echo "ERROR: Output file not created"
    exit 1
fi
