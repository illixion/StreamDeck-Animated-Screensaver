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

# Get the input file name without extension
input_video="$1"
input_video_base=$(basename -- "$1")
extension="${input_video_base##*.}"
input_video_name="${input_video_base%.*}"

# Output directory for webp files
output_dir="./tmp"

# Template directory
template_dir="./template"

# Create output directory if it doesn't exist
rm -r "$output_dir" 2>/dev/null
mkdir -p "$output_dir"

# Get video width and height
video_info=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$input_video")
width=$(echo "$video_info" | cut -d ',' -f 1)
height=$(echo "$video_info" | cut -d ',' -f 2)

# Calculate grid cell width and height
cell_width=$((width / 5))
cell_height=$((height / 3))

# Calculate 10% of cell width and height
skip_width=$((cell_width / 10))
skip_height=$((cell_height / 10))

# Loop through grid cells
for i in $(seq 0 4); do
  for j in $(seq 0 2); do
    # Calculate crop coordinates
    x=$((i * cell_width + skip_width))
    y=$((j * cell_height + skip_height))

    # Calculate crop width and height
    crop_width=$((cell_width - 2 * skip_width))
    crop_height=$((cell_height - 2 * skip_height))

    # Create webp filename
    output_webp="$output_dir/segment_$((i + 1))_$((j + 1)).webp"

    # Extract and convert cell to webp
    ffmpeg -i "$input_video" -vf "crop=${crop_width}:${crop_height}:${x}:${y},scale=144:-1:flags=lanczos,fps=fps=30" -q:v 100 -loop 0 "$output_webp"
  done
done

# Create a copy of the template directory
template_copy="$(basename "$template_dir")-copy"
rm -r "$template_copy" 2>/dev/null
cp -cr "$template_dir" "$template_copy"

# Replace the template's image files with the generated webp files
for i in $(seq 0 4); do
  for j in $(seq 0 2); do
    input_webp="$output_dir/segment_$((i + 1))_$((j + 1)).webp"
    output_webp="$template_copy/91EBCF7F-C727-43EF-BE2F-58EE5B617867.sdProfile/Profiles/CS3KF237953I337M0QTB32DD3KZ/Images/segment_$((i))_$((j)).webp"
    mv "$input_webp" "$output_webp"
  done
done

# Replace "FILENAME" with the input video's file name in the template's manifest.json
sed -i "" "s/FILENAME/$input_video_name/" "$template_copy/91EBCF7F-C727-43EF-BE2F-58EE5B617867.sdProfile/manifest.json"

# Create a ZIP file using 7z
output_zip="${input_video_name}.streamDeckProfile"
cd "$template_copy"
7z a -tzip "../$output_zip" "91EBCF7F-C727-43EF-BE2F-58EE5B617867.sdProfile"

# Clean up temporary files
cd ..
rm -r "$output_dir" "$template_copy" 2>/dev/null
