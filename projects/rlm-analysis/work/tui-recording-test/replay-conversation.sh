#!/bin/bash
# Replay a pre-recorded AI conversation with realistic timing
# This creates a realistic demo without needing actual API calls
#
# Usage: ./replay-conversation.sh <conversation.json> [output-name]
#
# Conversation JSON format:
# {
#   "cli": "claude",
#   "exchanges": [
#     {"user": "prompt text", "assistant": "response text", "delay": 2},
#     ...
#   ]
# }

set -e

CONVERSATION_FILE="${1:-conversation.json}"
OUTPUT="${2:-replay-demo}"

# Colors for TUI simulation
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
WHITE='\033[97m'
BLUE='\033[34m'
MAGENTA='\033[35m'

# Typing effect - simulates human typing
type_slowly() {
    local text="$1"
    local delay="${2:-0.04}"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
}

# Streaming effect - simulates AI response streaming
stream_text() {
    local text="$1"
    local delay="${2:-0.008}"
    for word in $text; do
        printf "%s " "$word"
        sleep "$delay"
    done
}

# Render Claude Code-like TUI header
render_header() {
    echo -e "${BOLD}${BLUE}╭─────────────────────────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${BLUE}│${RESET}  ${WHITE}${BOLD}Claude Code${RESET}  ${DIM}v2.1.7${RESET}                                                      ${BLUE}│${RESET}"
    echo -e "${BOLD}${BLUE}│${RESET}  ${DIM}Working directory: $(pwd | head -c 50)${RESET}                    ${BLUE}│${RESET}"
    echo -e "${BOLD}${BLUE}╰─────────────────────────────────────────────────────────────────────────────╯${RESET}"
    echo ""
}

# Render user prompt
render_user_prompt() {
    local prompt="$1"
    echo -e "${BOLD}${YELLOW}❯${RESET} "
    type_slowly "$prompt" 0.05
    echo ""
    echo ""
}

# Render assistant response
render_assistant_response() {
    local response="$1"
    echo -e "${BOLD}${GREEN}Claude:${RESET}"
    stream_text "$response" 0.01
    echo ""
    echo ""
}

# Render tool use
render_tool_use() {
    local tool="$1"
    local detail="$2"
    echo -e "  ${DIM}${CYAN}⚡ $tool${RESET}"
    if [[ -n "$detail" ]]; then
        echo -e "  ${DIM}$detail${RESET}"
    fi
    sleep 0.5
}

# Main replay function
replay_demo() {
    clear
    render_header
    sleep 1

    # If JSON file provided, parse it. Otherwise use hardcoded demo.
    if [[ -f "$CONVERSATION_FILE" ]]; then
        # Parse JSON with jq if available
        if command -v jq &> /dev/null; then
            local exchanges
            exchanges=$(jq -r '.exchanges | length' "$CONVERSATION_FILE")
            for ((i=0; i<exchanges; i++)); do
                user=$(jq -r ".exchanges[$i].user" "$CONVERSATION_FILE")
                assistant=$(jq -r ".exchanges[$i].assistant" "$CONVERSATION_FILE")
                delay=$(jq -r ".exchanges[$i].delay // 2" "$CONVERSATION_FILE")
                tool=$(jq -r ".exchanges[$i].tool // empty" "$CONVERSATION_FILE")

                render_user_prompt "$user"
                [[ -n "$tool" ]] && render_tool_use "$tool"
                render_assistant_response "$assistant"
                sleep "$delay"
            done
        else
            echo "jq not found, using hardcoded demo"
            run_hardcoded_demo
        fi
    else
        run_hardcoded_demo
    fi

    # Exit sequence
    echo -e "${BOLD}${YELLOW}❯${RESET} "
    type_slowly "/exit" 0.1
    echo ""
    sleep 0.5
    echo -e "${DIM}Goodbye!${RESET}"
    sleep 1
}

# Hardcoded demo for testing
run_hardcoded_demo() {
    # Exchange 1
    render_user_prompt "What files are in this project?"
    render_tool_use "Glob" "pattern: **/*"
    sleep 0.3
    render_assistant_response "I found the following files in your project:

  src/
    main.rs      - Entry point with CLI argument parsing
    lib.rs       - Core library functions
    config.rs    - Configuration handling

  tests/
    integration_test.rs

  Cargo.toml     - Project manifest
  README.md      - Documentation"
    sleep 2

    # Exchange 2
    render_user_prompt "Add a --verbose flag to enable debug logging"
    render_tool_use "Read" "src/main.rs"
    sleep 0.5
    render_tool_use "Edit" "src/main.rs"
    sleep 0.3
    render_assistant_response "I've added the --verbose flag to your CLI. Here's what I changed:

  ✓ Added -v/--verbose argument using clap
  ✓ Connected it to the tracing subscriber
  ✓ When enabled, sets log level to DEBUG

You can now run: cargo run -- --verbose"
    sleep 2

    # Exchange 3
    render_user_prompt "Run the tests"
    render_tool_use "Bash" "cargo test"
    sleep 1
    render_assistant_response "All tests passed!

  running 3 tests
  test config::tests::test_default_config ... ok
  test lib::tests::test_process ... ok
  test integration::test_cli ... ok

  test result: ok. 3 passed; 0 failed"
    sleep 2
}

# Record the replay with asciinema
echo "=== AI Conversation Replay ==="
echo "Recording replay demo..."
echo ""

# Run asciinema with the replay function
asciinema rec --overwrite "${OUTPUT}.cast" -c "bash -c '$(declare -f type_slowly stream_text render_header render_user_prompt render_assistant_response render_tool_use replay_demo run_hardcoded_demo); CONVERSATION_FILE=\"$CONVERSATION_FILE\" replay_demo'"

echo ""
echo "Recording complete: ${OUTPUT}.cast"

# Convert to GIF
if command -v agg &> /dev/null; then
    echo "Converting to GIF..."
    agg "${OUTPUT}.cast" "${OUTPUT}.gif" --font-size 16 --cols 100 --rows 35
    echo "Created: ${OUTPUT}.gif"
fi

# Convert to MP4
if command -v ffmpeg &> /dev/null && [[ -f "${OUTPUT}.gif" ]]; then
    echo "Converting to MP4..."
    ffmpeg -y -i "${OUTPUT}.gif" -movflags faststart -pix_fmt yuv420p \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${OUTPUT}.mp4" 2>/dev/null
    echo "Created: ${OUTPUT}.mp4"
fi

echo ""
echo "=== Files Created ==="
ls -la "${OUTPUT}".*
