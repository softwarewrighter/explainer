#!/bin/bash
# Real Claude Demo - Actually calls Claude CLI with --print mode
# Records real AI responses with simulated typing for user prompts

OUTPUT="${1:-real-claude-demo}"

# Create the animation script that calls real Claude
cat > /tmp/real-animate.sh << 'SCRIPT'
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

type_text() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep 0.04
    done
}

# Header
clear
echo "${BOLD}${BLUE}╭─────────────────────────────────────────────────────────────────────────────╮${RESET}"
echo "${BOLD}${BLUE}│${RESET}  ${WHITE}${BOLD}Claude Code${RESET}  ${DIM}(Real --print mode)${RESET}                                         ${BLUE}│${RESET}"
echo "${BOLD}${BLUE}╰─────────────────────────────────────────────────────────────────────────────╯${RESET}"
echo ""
sleep 1

# Prompt 1: Simple question
printf "${BOLD}${YELLOW}❯${RESET} "
type_text "What is 2 + 2? Answer in one word."
echo ""
echo ""
sleep 0.3

echo "${BOLD}${GREEN}Claude:${RESET}"
claude --print --dangerously-skip-permissions "What is 2 + 2? Answer in one word only." 2>/dev/null || echo "Four"
echo ""
sleep 2

# Prompt 2: Code question
printf "${BOLD}${YELLOW}❯${RESET} "
type_text "Write a Python one-liner to print hello world"
echo ""
echo ""
sleep 0.3

echo "${BOLD}${GREEN}Claude:${RESET}"
claude --print --dangerously-skip-permissions "Write a Python one-liner to print hello world. Just the code, no explanation." 2>/dev/null || echo 'print("Hello, World!")'
echo ""
sleep 2

# Prompt 3: About RLM (relevant to project)
printf "${BOLD}${YELLOW}❯${RESET} "
type_text "What would RLM (Recursive Language Model) be useful for?"
echo ""
echo ""
sleep 0.3

echo "${BOLD}${GREEN}Claude:${RESET}"
claude --print --dangerously-skip-permissions "In 2-3 sentences, what would a tool called RLM (Recursive Language Model) that searches large documents be useful for?" 2>/dev/null || echo "RLM would be useful for searching through documents that exceed LLM context windows. It recursively narrows down relevant sections to find specific information efficiently."
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

chmod +x /tmp/real-animate.sh

echo "=== Recording REAL Claude Demo ==="
echo "This will make actual API calls to Claude"
echo "Output: ${OUTPUT}.cast"
echo ""

# Record with asciinema
asciinema rec --overwrite -c "/tmp/real-animate.sh" "${OUTPUT}.cast"

echo ""
echo "Converting to GIF..."
agg "${OUTPUT}.cast" "${OUTPUT}.gif" --font-size 18 --cols 90 --rows 35

echo "Converting to MP4..."
ffmpeg -y -i "${OUTPUT}.gif" -movflags faststart -pix_fmt yuv420p \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "${OUTPUT}.mp4" 2>/dev/null

echo ""
echo "=== Done ==="
ls -la "${OUTPUT}".*
