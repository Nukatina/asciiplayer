#!/usr/bin/env bash
# asciiplayer — Play any video as ASCII art in your terminal
# Works in GitHub CodeSpaces • Zero audio hassle • Pure Bash + ffmpeg
# Updated Dec 2025: Debug + auto-generate demo

set -euo pipefail
trap 'tput cnorm; clear; exit' INT TERM EXIT
tput civis

# Colors
G='\033[38;5;82m'; Y='\033[38;5;226m'; R='\033[38;5;196m'; C='\033[38;5;51m'; W='\033[97m'; X='\033[0m'

# ASCII ramp (dark to bright)
CHARS=' .:-=+*#%@'

clear
echo -e "${C}╔══════════════════════════════════════════════════╗${X}"
echo -e "${C}║           asciiplayer — Terminal Video Player     ║${X}"
echo -e "${C}╚══════════════════════════════════════════════════╝${X}"
sleep 1.5

INPUT="${1:-demo.mp4}"

# Auto-generate demo if file missing
if [[ ! -f "$INPUT" ]]; then
    echo -e "${Y}No $INPUT found — generating a quick demo video...${X}"
    ffmpeg -f lavfi -i testsrc2=duration=15:size=320x240:rate=25 -c:v libx264 -pix_fmt yuv420p "$INPUT" -y >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "${R}FFmpeg failed — install with ./install-deps.sh${X}"
        exit 1
    fi
    echo -e "${G}Demo generated! (Colorful test pattern)${X}"
fi

if [[ "$INPUT" =~ ^https?:// ]]; then
    echo -e "${Y}Downloading YouTube video...${X}"
    yt-dlp -f "worst[height<=480]" --quiet --no-warnings --user-agent "Mozilla/5.0" -o /tmp/asciivid.mp4 "$INPUT" 2>/dev/null || {
        echo -e "${R}Download failed — falling back to demo.mp4${X}"
        INPUT="demo.mp4"
    }
    INPUT="/tmp/asciivid.mp4"
fi

echo -e "${G}Converting & playing: $INPUT  (Ctrl+C to stop)${X}"

# Pipe frames safely with dd (fixed read size)
ffmpeg -i "$INPUT" -vf "scale=80:40,fps=7,format=monob" -f rawvideo -pix_fmt monob - 2>/dev/null | \
while true; do
    frame=$(dd bs=1 count=3200 iflag=fullblock 2>/dev/null) || break  # 80x40=3200 bytes per frame
    if [[ ${#frame} -lt 3200 ]]; then break; fi  # End of video

    clear
    for ((i=0; i<40; i++)); do
        row=""
        for ((j=0; j<80; j++)); do
            byte=${frame:$((i*80 + j)):1}
            pixel=$(printf '%d' "'$byte")  # Ordinal value (0-255)
            level=$(( pixel * (${#CHARS}-1) / 255 ))
            row+="${CHARS:$level:1}"
        done
        echo -e "${W}$row${X}"
    done
    echo -e "${C}asciiplayer • Frame time: $(date +%H:%M:%S) • Ctrl+C to quit${X}"
    sleep 0.15  # Smooth refresh
done

rm -f /tmp/asciivid.mp4  # Cleanup
