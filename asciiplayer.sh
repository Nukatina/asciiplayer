#!/usr/bin/env bash
# asciiplayer — Play any video as ASCII art in your terminal
# Works in GitHub CodeSpaces • Zero audio hassle • Pure Bash + ffmpeg

set -euo pipefail
trap 'tput cnorm; clear; exit' INT TERM EXIT
tput civis

# Colors (optional flair)
G='\033[38;5;82m'   # Green
Y='\033[38;5;226m'  # Yellow
R='\033[38;5;196m'  # Red
C='\033[38;5;51m'   # Cyan
W='\033[97m'
X='\033[0m'

# ASCII ramp (darker → brighter)
CHARS=' .:-=+*#%@'

clear
echo -e "${C}╔══════════════════════════════════════════════════╗${X}"
echo -e "${C}║           asciiplayer — Terminal Video Player     ║${X}"
echo -e "${C}╚══════════════════════════════════════════════════╝${X}"
sleep 1.5

INPUT="${1:-demo.mp4}"

if [[ "$INPUT" =~ ^https?:// ]]; then
    echo -e "${Y}Downloading video (yt-dlp)...${X}"
    yt-dlp -f "worst" --quiet --no-warnings -o - "$INPUT" > /tmp/asciivid.mp4 2>/dev/null || {
        echo "YouTube failed → using built-in demo.mp4"
        INPUT="demo.mp4"
    }
    INPUT="/tmp/asciivid.mp4"
fi

echo -e "${G}Playing: $INPUT  (Ctrl+C to stop)${X}"

ffmpeg -i "$INPUT" -vf "scale=80:40,format=gray" -f rawvideo - 2>/dev/null | \
while IFS= read -r -d '' -n $((80*40)) frame; do
    clear
    for ((i=0; i<40; i++)); do
        for ((j=0; j<80; j++)); do
            pixel=$(printf '%d' "0x${frame:$((i*80+j)):1}")
            level=$(( pixel * (${#CHARS}-1) / 255 ))
            printf '%b%s%b' "${W}" "${CHARS:$level:1}" "${X}"
        done
        echo
    done
    echo -e "${C}asciiplayer • $(date +%H:%M:%S) • Ctrl+C to quit${X}"
    sleep 0.08
done
