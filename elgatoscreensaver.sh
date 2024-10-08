#!/bin/bash

# Exit on error
set -e

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Change into the script's directory
cd "$SCRIPT_DIR" || exit

# Input video
if [ ! -f "$1" ]; then
  echo "Input file not found"
  exit 1
fi

streamDeckX=5
streamDeckY=3
templateId="91EBCF7F-C727-43EF-BE2F-58EE5B617867"
if [ "$2" = "XL" ]; then
  streamDeckX=8
  streamDeckY=4
  templateId="91EBCF7F-C727-43EF-BE2F-58EE5B617868"
fi  

# Get the input file name without extension
input_video="$1"
input_video_base=$(basename -- "$1")
extension="${input_video_base##*.}"
input_video_name="${input_video_base%.*}"

# Output directory for webp files
output_dir="./template/${templateId}.sdProfile/Profiles/CS3KF237953I337M0QTB32DD3KZ/Images"

# Template directory
template_dir="./template"

# Create output directory if it doesn't exist
rm -r "$output_dir" 2>/dev/null || true
mkdir -p "$output_dir"

# Get video width and height
video_info=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$input_video")
width=$(echo "$video_info" | cut -d ',' -f 1)
height=$(echo "$video_info" | cut -d ',' -f 2)

# Calculate grid cell width and height
cell_width=$((width / streamDeckX))
cell_height=$((height / streamDeckY))

# Calculate 10% of cell width and height
skip_width=$((cell_width / 10))
skip_height=$((cell_height / 10))

# Loop through grid cells
for i in $(seq 0 $((streamDeckX - 1))); do
  for j in $(seq 0 $((streamDeckY - 1))); do
    # Calculate crop coordinates
    x=$((i * cell_width + skip_width))
    y=$((j * cell_height + skip_height))

    # Calculate crop width and height
    crop_width=$((cell_width - 2 * skip_width))
    crop_height=$((cell_height - 2 * skip_height))

    # Create webp filename
    output_webp="$output_dir/segment_$((i))_$((j)).webp"

    # Extract and convert cell to webp
    ffmpeg -i "$input_video" -vf "crop=${crop_width}:${crop_height}:${x}:${y},scale=144:-1:flags=lanczos,fps=fps=30" -q:v 100 -loop 0 "$output_webp"
  done
done

# Create a copy of the template directory
template_copy="$(basename "$template_dir")-copy"
rm -r "$template_copy" 2>/dev/null || true
cp -r "$template_dir" "$template_copy"

# Replace "FILENAME" with the input video's file name in the template's manifest.json
# Also ensure sed works on both macOS and Linux
if [ "$(uname)" == "Darwin" ]; then
    sed -i "" "s/FILENAME/$input_video_name/" "$template_copy/${templateId}.sdProfile/manifest.json"
else
    sed -i "s/FILENAME/$input_video_name/" "$template_copy/${templateId}.sdProfile/manifest.json"
fi

# Create a ZIP file using 7z
output_zip="${input_video_name}.streamDeckProfile"
cd "$template_copy"
7z a -tzip "../$output_zip" "${templateId}.sdProfile"

# Clean up temporary files
cd ..
rm -r "$output_dir" "$template_copy" 2>/dev/null || true
