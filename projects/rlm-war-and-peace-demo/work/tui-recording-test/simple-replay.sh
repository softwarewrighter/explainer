#!/bin/bash
# Simple TUI replay - writes animation script to temp file and records it

OUTPUT="${1:-demo}"

# Create the animation script
cat > /tmp/animate-demo.sh << 'SCRIPT'
#!/bin/bash

# Colors
RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
WHITE=$'\033[97m'
BLUE=$'\033[34m'

type_char() {
    printf "%s" "$1"
    sleep 0.04
}

type_text() {
    local text="$1"
    local i
    for ((i=0; i<${#text}; i++)); do
        type_char "${text:$i:1}"
    done
}

stream_words() {
    for word in $@; do
        printf "%s " "$word"
        sleep 0.02
    done
}

clear

# Header
echo "${BOLD}${BLUE}╭─────────────────────────────────────────────────────────────────────────────╮${RESET}"
echo "${BOLD}${BLUE}│${RESET}  ${WHITE}${BOLD}Claude Code${RESET}  ${DIM}v2.1.7${RESET}                                                      ${BLUE}│${RESET}"
echo "${BOLD}${BLUE}╰─────────────────────────────────────────────────────────────────────────────╯${RESET}"
echo ""
sleep 1

# Exchange 1
printf "${BOLD}${YELLOW}❯${RESET} "
type_text "What files are in this project?"
echo ""
echo ""
sleep 0.5

echo "  ${DIM}${CYAN}⚡ Glob${RESET} pattern: **/*"
sleep 0.3

echo "${BOLD}${GREEN}Claude:${RESET}"
stream_words "I found the following files in your project:"
echo ""
echo ""
echo "  src/"
sleep 0.1
echo "    main.rs      - Entry point"
sleep 0.1
echo "    lib.rs       - Core library"
sleep 0.1
echo "    config.rs    - Configuration"
echo ""
echo "  Cargo.toml"
echo "  README.md"
echo ""
sleep 2

# Exchange 2
printf "${BOLD}${YELLOW}❯${RESET} "
type_text "Add a --verbose flag for debugging"
echo ""
echo ""
sleep 0.5

echo "  ${DIM}${CYAN}⚡ Read${RESET} src/main.rs"
sleep 0.4
echo "  ${DIM}${CYAN}⚡ Edit${RESET} src/main.rs"
sleep 0.3

echo "${BOLD}${GREEN}Claude:${RESET}"
stream_words "I've added the --verbose flag. Changes made:"
echo ""
echo ""
echo "  ✓ Added -v/--verbose argument"
sleep 0.1
echo "  ✓ Connected to tracing subscriber"
sleep 0.1
echo "  ✓ Sets log level to DEBUG when enabled"
echo ""
sleep 2

# Exchange 3
printf "${BOLD}${YELLOW}❯${RESET} "
type_text "Run the tests"
echo ""
echo ""
sleep 0.5

echo "  ${DIM}${CYAN}⚡ Bash${RESET} cargo test"
sleep 0.8

echo "${BOLD}${GREEN}Claude:${RESET}"
stream_words "All tests passed!"
echo ""
echo ""
echo "  running 3 tests"
sleep 0.2
echo "  test config::test_default ... ${GREEN}ok${RESET}"
sleep 0.2
echo "  test lib::test_process ... ${GREEN}ok${RESET}"
sleep 0.2
echo "  test integration::test_cli ... ${GREEN}ok${RESET}"
echo ""
echo "  test result: ${GREEN}ok${RESET}. 3 passed"
echo ""
sleep 2

# Exit
printf "${BOLD}${YELLOW}❯${RESET} "
type_text "/exit"
echo ""
sleep 0.3
echo "${DIM}Goodbye!${RESET}"
sleep 1
SCRIPT

chmod +x /tmp/animate-demo.sh

echo "=== Recording TUI Demo ==="
echo "Output: ${OUTPUT}.cast"
echo ""

# Record with asciinema
asciinema rec --overwrite -c "/tmp/animate-demo.sh" "${OUTPUT}.cast"

echo ""
echo "Converting to GIF..."
agg "${OUTPUT}.cast" "${OUTPUT}.gif" --font-size 18 --cols 90 --rows 35

echo "Converting to MP4..."
ffmpeg -y -i "${OUTPUT}.gif" -movflags faststart -pix_fmt yuv420p \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${OUTPUT}.mp4" 2>/dev/null

echo ""
echo "=== Done ==="
ls -la "${OUTPUT}".*
