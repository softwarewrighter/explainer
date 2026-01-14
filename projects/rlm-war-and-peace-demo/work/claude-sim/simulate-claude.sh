#!/bin/bash
# Simulates a Claude Code-like CLI interaction for recording
# Uses ANSI colors and typing effects

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RESET='\033[0m'
BOLD='\033[1m'

# Typing effect
type_text() {
    local text="$1"
    local delay="${2:-0.03}"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
}

# Print Claude response with streaming effect
claude_response() {
    local text="$1"
    local delay="${2:-0.01}"
    echo -e "${GREEN}Claude:${RESET}"
    for word in $text; do
        printf "%s " "$word"
        sleep "$delay"
    done
    echo
    echo
}

clear

# Header
echo -e "${BOLD}${CYAN}╭─────────────────────────────────────────────────────────╮${RESET}"
echo -e "${BOLD}${CYAN}│${RESET}  ${WHITE}Claude Code${RESET}  ${GRAY}v1.0.0${RESET}                                   ${CYAN}│${RESET}"
echo -e "${BOLD}${CYAN}╰─────────────────────────────────────────────────────────╯${RESET}"
echo
sleep 1

# User prompt
echo -e "${YELLOW}You:${RESET} "
type_text "What files are in this project?" 0.05
echo
sleep 0.5
echo

# Claude response
claude_response "Let me check the files in this project for you." 0.02
sleep 0.3

echo -e "${GRAY}Reading directory...${RESET}"
sleep 0.5
echo
echo -e "${WHITE}Found 12 files:${RESET}"
echo "  src/"
echo "    main.rs"
echo "    lib.rs"
echo "    config.rs"
echo "  tests/"
echo "    integration_test.rs"
echo "  Cargo.toml"
echo "  README.md"
echo
sleep 1

# Second interaction
echo -e "${YELLOW}You:${RESET} "
type_text "Can you explain what main.rs does?" 0.05
echo
sleep 0.5
echo

claude_response "I'll read main.rs and explain its purpose." 0.02
sleep 0.3

echo -e "${GRAY}Reading src/main.rs...${RESET}"
sleep 0.8
echo
echo -e "${WHITE}Summary:${RESET}"
echo "  • Entry point for the CLI application"
echo "  • Parses command-line arguments using clap"
echo "  • Initializes logging with tracing"
echo "  • Calls the main processing function from lib.rs"
echo
sleep 1

# Third interaction
echo -e "${YELLOW}You:${RESET} "
type_text "Add a --verbose flag to the CLI" 0.05
echo
sleep 0.5
echo

claude_response "I'll add a verbose flag to the CLI. Let me edit the argument parser." 0.02
sleep 0.5

echo -e "${GRAY}Editing src/main.rs...${RESET}"
sleep 0.3
echo -e "${GREEN}✓${RESET} Added --verbose / -v flag"
echo -e "${GREEN}✓${RESET} Updated help text"
echo -e "${GREEN}✓${RESET} Connected to logging configuration"
echo
sleep 0.5

echo -e "${WHITE}Changes made:${RESET}"
echo -e "  ${CYAN}src/main.rs${RESET} - Added verbose argument"
echo
sleep 1

# Exit
echo -e "${YELLOW}You:${RESET} "
type_text "/exit" 0.08
echo
sleep 0.3
echo
echo -e "${GRAY}Goodbye!${RESET}"
sleep 1
