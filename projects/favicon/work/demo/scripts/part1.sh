#!/bin/bash
# Favicon Demo Part 1: Text Favicons
# Run this script and follow the prompts

# Demo 1: Two letters
clear
echo 'favicon --text "AB"'
echo
favicon --text "AB"
read -p "Press Enter to view..."
display favicon.ico
clear

# Demo 2: Single letter as PNG
echo 'favicon --text "X" --png'
echo
favicon --text "X" --png
read -p "Press Enter to view..."
display favicon.png
clear

# Demo 3: Custom output path
echo 'favicon -t "SW" -o initials.ico'
echo
favicon -t "SW" -o initials.ico
read -p "Press Enter to view..."
display initials.ico
clear

echo "Part 1 complete!"
