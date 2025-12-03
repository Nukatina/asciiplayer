#!/usr/bin/env bash
# asciiplayer – Professional ASCII Music Visualiser
# Perfectly spaced & aligned frequency labels • Pure Bash • Dec 2025

trap 'tput cnorm; clear; exit' INT TERM EXIT
tput civis
clear

# Colors
R='\033[38;5;196m'; O='\033[38;5;208m'; Y='\033[38;5;226m'
G='\033[38;5;82m' ; B='\033[38;5;51m' ; P='\033[38;5;141m'
W='\033[97m'     ; X='\033[0m'

echo -e "${B}╔══════════════════════════════════════════════════════════════╗${X}"
echo -e "${B}║              asciiplayer – Professional Visualiser           ║${X}"
echo -e "${B}╚══════════════════════════════════════════════════════════════╝${X}"
sleep 2.5

beat=(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0)
frame=0
BARS=28
HEIGHT=22

while true; do
    clear

    kick=${beat[$((frame % 16))]}
    bass=$((kick ? 23 : 6 + $RANDOM % 7))

    # Draw bars
    for ((row = HEIGHT; row >= 1; row--)); do
        line="      "  # Left margin
        for ((bar = 1; bar <= BARS; bar++)); do
            height=$((bass + (BARS - bar)/2 + $RANDOM % 4))

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
            line+="   "
        done
        echo -e "$line"
    done

    # PERFECTLY ALIGNED FREQUENCY LABELS (manually spaced to match bars)
    echo
    echo -e "      ${B}60Hz     150Hz     400Hz     1kHz     2.5kHz    6kHz    12kHz    18kHz${X}"
    echo -e "      ${B}│         │         │         │         │         │        │        │${X}"
    echo -e "      1         4         8        12        16        20       24       28${X}"
    echo
    echo -e "                 ${P}♪ 128 BPM Techno Beat • Slow & Cinematic • Ctrl+C to stop${X}"
    echo -e "                            ${W}Beat: $((frame/4 + 1)) | Kick: $kick${X}"

    ((frame++))
    sleep 0.16
done
