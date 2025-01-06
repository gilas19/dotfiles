#!/usr/bin/env zsh
# created by gilad ticher

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    printf "ImageMagick is not installed. Do you want to install it using Homebrew? (y/n): "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        brew install ImageMagick
    else
        echo "ImageMagick is required for this script. Exiting."
        exit 1
    fi
fi
fi

# Get input location
if [ -z "$1" ]; then
    location=$(pwd)
else
    location="$1"
fi

# Create a folder for converted files
folder="$location/converted"
mkdir -p "$folder"

# Convert JPEG files to PDF
for file in "$location"/*.jpeg; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        filename="${filename%.*}"
        convert "$file" "$folder/$filename.pdf"
        echo "Converted $file to $folder/$filename.pdf"
    fi
done

echo "Conversion complete!"
