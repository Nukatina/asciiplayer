#!/usr/bin/env bash
echo "Installing ffmpeg + yt-dlp (30 seconds)..."
sudo apt update -qq && sudo apt install -y ffmpeg yt-dlp > /dev/null 2>&1
echo "Ready! Run: ./asciiplayer.sh"
