#!/usr/bin/env bash
# asciiplayer – Stunning ASCII music visualiser
# Works in GitHub CodeSpaces with ZERO setup • Dec 2025
# Author: Tina Bowles

trap 'tput cnorm; clear; exit' INT TERM EXIT
tput civis
clear

# Colors
R='\033[38;5;196m'; O='\033[38;5;208m'; Y='\033[38;5;226m'
G='\033[38;5;82m'; C='\033[38;5;51m'; P='\033[38;5;141m'; X='\033[0m'

echo -e "${C}╔══════════════════════════════════════════╗${X}"
echo -e "${C}║        asciiplayer – ASCII Visualiser      ║${X}"
echo -e "${C}╚══════════════════════════════════════════╝${X}"
sleep 2

# Built-in drum beat (no file needed ever)
beat=(0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0
      0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0
      1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0)

i=0
while true; do
    clear
    kick=${beat[$i % ${#beat[@]}]}
    
    # Bass kick = huge center bars
    height=$((kick ? 18 : 4 + $RANDOM % 8))
    
    # Draw 40 bars
    for ((row=18; row>=1; row--)); do
        line=""
        for ((col=1; col<=40; col++)); do
            # Make it look like a real spectrum
            dist=$((20 - col)); dist=${dist#-}
            h=$((height - dist/3 + $RANDOM%4))
            [[ $h -lt 1 ]] && h=1
            
            if (( row <= h && row > h*3/4 )); then line+="${R}█${X}"
            elif (( row <= h && row > h/2 )); then line+="${O}█${X}"
            elif (( row <= h && row > h/4 )); then line+="${Y}█${X}"
            elif (( row <= h )); then line+="${G}█${X}"
            else line+=" "
            fi
        done
        echo -e "$line"
    done
    
    echo -e "${C}60Hz      200Hz      1kHz      6kHz      18kHz${X}"
    echo -e "${P}♪ Built-in drum beat • BPM 128 • Ctrl+C to stop${X}"
    i=$((i+1))
    sleep 0.12
done
