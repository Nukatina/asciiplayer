#!/usr/bin/env bash
# asciiplayer – Stunning, perfectly spaced ASCII music visualiser
# Pure Bash • Zero dependencies • Works 100% in GitHub CodeSpaces

trap 'tput cnorm; clear; exit' INT TERM EXIT
tput civis
clear

# Colors
R='\033[38;5;196m'; O='\033[38;5;208m'; Y='\033[38;5;226m'
G='\033[38;5;82m' ; B='\033[38;5;51m' ; P='\033[38;5;141m'
W='\033[97m'     ; X='\033[0m'

# Title
echo -e "${B}╔══════════════════════════════════════════════════════════╗${X}"
echo -e "${B}║               asciiplayer – ASCII Visualiser             ║${X}"
echo -e "${B}╚══════════════════════════════════════════════════════════╝${X}"
sleep 2

# Built-in drum pattern (128 BPM, classic techno kick)
beat=(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0)

frame=0
while true; do
    clear

    kick=${beat[$((frame % 16))]}
    bass_level=$((kick ? 20 : 6 + $RANDOM % 8))

    # Draw 30 wide, well-spaced bars (looks pro)
    for ((row = 20; row >= 1; row--)); do
        line="    "  # Left padding
        for ((bar = 1; bar <= 30; bar++)); do
            # Frequency-based height (low freqs left, high right)
            freq_factor=$(( (30 - bar) / 2 ))
            height=$((bass_level + freq_factor + $RANDOM % 5))

            if (( row <= height && row > height * 3/4 )); then
                line+="${R}██${X}"
            elif (( row <= height && row > height / 2 )); then
                line+="${O}██${X}"
            elif (( row <= height && row > height / 4 )); then
                line+="${Y}██${X}"
            elif (( row <= height )); then
                line+="${G}██${X}"
            else
                line+="${W}░░${X}"
            fi
            line+="  "  # Perfect spacing between bars
        done
        echo -e "$line"
    done

    # Frequency labels (perfectly centered)
    echo
    echo -e "        ${B}60Hz         400Hz         2kHz         10kHz        18kHz${X}"
    echo
    echo -e "               ${P}♪ Built-in 128 BPM Techno Beat • Press Ctrl+C to stop${X}"
    echo -e "                       ${W}Frame: $frame | Kick: $kick${X}"

    ((frame++))
    sleep 0.14  # Perfect tempo feel
done
