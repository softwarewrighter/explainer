#!/bin/bash
# Generate video production script from repo + topic
# Usage: ./generate-script.sh --repo <path> --topic "topic" [--output script.json]

set -e

REPO=""
TOPIC=""
OUTPUT="script.json"

while [[ $# -gt 0 ]]; do
    case $1 in
        --repo) REPO="$2"; shift 2 ;;
        --topic) TOPIC="$2"; shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ -z "$REPO" || -z "$TOPIC" ]]; then
    echo "Usage: $0 --repo <path> --topic \"topic\" [--output script.json]"
    exit 1
fi

REPO=$(realpath "$REPO")

echo "=== Video Script Generator ==="
echo "Repo: $REPO"
echo "Topic: $TOPIC"
echo "Output: $OUTPUT"
echo ""

# Generate the prompt for Claude
PROMPT=$(cat << 'PROMPT_END'
You are a video script generator. Analyze the repository and create a JSON script for an explainer video.

REPOSITORY: {{REPO}}
TOPIC: {{TOPIC}}

Generate a script.json with this structure:
{
  "title": "Video title",
  "repo": "{{REPO}}",
  "duration_estimate": "90-120 seconds",
  "segments": [
    {
      "id": "01-hook",
      "type": "avatar",
      "duration": 5,
      "narration": "Hook text (VibeVoice: no contractions, spell out acronyms like 'R L M')",
      "svg_description": "Background description for SVG generation"
    },
    {
      "id": "02-problem",
      "type": "diagram",
      "duration": 10,
      "narration": "Problem explanation",
      "svg_description": "Diagram showing the problem"
    },
    {
      "id": "03-demo",
      "type": "cli",
      "duration": 15,
      "cli": "rlm",
      "narration": "What we're seeing in the demo",
      "vhs_tape": "VHS tape content to record the demo"
    },
    ...
  ]
}

Segment types:
- "avatar": Lip-synced presenter with SVG background
- "diagram": Generated SVG diagram/flowchart
- "cli": VHS-recorded CLI demo (claude, rlm, opencode, etc.)
- "image": Static image with Ken Burns effect

For CLI segments, include complete VHS tape content that will record the demo.

For narration, follow VibeVoice guidelines:
- No contractions (use "do not" not "don't")
- Spell out acronyms with spaces ("R L M" not "RLM")
- Use periods and commas only (no semicolons, colons, dashes)

Output ONLY valid JSON, no markdown or explanation.
PROMPT_END
)

# Replace placeholders
PROMPT="${PROMPT//\{\{REPO\}\}/$REPO}"
PROMPT="${PROMPT//\{\{TOPIC\}\}/$TOPIC}"

echo "Generating script with Claude..."
echo ""

# Call Claude to generate the script
claude --print --dangerously-skip-permissions "$PROMPT" > "$OUTPUT" 2>/dev/null

# Validate JSON
if jq empty "$OUTPUT" 2>/dev/null; then
    echo "✓ Valid JSON generated"
    echo ""
    echo "Segments:"
    jq -r '.segments[] | "  \(.id): \(.type) (\(.duration)s)"' "$OUTPUT"
    echo ""
    echo "Script saved to: $OUTPUT"
else
    echo "✗ Invalid JSON generated"
    echo "Raw output:"
    cat "$OUTPUT"
    exit 1
fi
