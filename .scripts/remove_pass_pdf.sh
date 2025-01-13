#!/usr/bin/env zsh
# created by gilad ticher
if ! command -v qpdf &> /dev/null; then
    printf "qpdf is not installed. Do you want to install it using Homebrew? (y/n): "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        brew install qpdf
    else
        echo "qpdf is required for this script. Exiting."
        exit 1
    fi
fi

printf "PDF location (leave blank for current directory): "
read -r pdf_loc
pdf_loc="${pdf_loc:-$(pwd)}"

printf "PDF password: "
IFS= read -r pdf_pass

if [ -d "$pdf_loc" ]; then
    output_folder="$pdf_loc/PDFs without password"
    mkdir -p "$output_folder"
    
    # Enable nullglob to handle cases where no files match the pattern
    setopt nullglob
    
    for pdf_file in "$pdf_loc"/*.PDF "$pdf_loc"/*.pdf; do
        if [ -f "$pdf_file" ]; then
            output_file="$output_folder/$(basename "$pdf_file" .PDF).pdf"
            qpdf --decrypt --password="$pdf_pass" -- "$pdf_file" "$output_file"
            echo "Processed: $pdf_file"
        fi
    done
    
    # Optionally disable nullglob if you want to restore default behavior
    unsetopt nullglob
    
elif [ -f "$pdf_loc" ]; then
    output_file="$(dirname "$pdf_loc")/$(basename "$pdf_loc" .PDF)_without_password.pdf"
    qpdf --decrypt --password="$pdf_pass" -- "$pdf_loc" "$output_file"
    echo "Processed: $pdf_loc"
fi