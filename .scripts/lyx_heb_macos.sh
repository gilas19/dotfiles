#!/usr/bin/env zsh
# created by gilad ticher

# This script installs LyX with hebrew Fonts on macOS using Homebrew.
# It also creates a preferences file for LyX settings.
# Lyx setting works only with LyX version 2.4 and above.

# Exit on error
set -e

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Install Homebrew First!"
    exit 1
else
    echo "Homebrew is already installed."
fi

# Function to install LyX without preferences and settings
install() {
    echo "Installing MacTeX and LyX..."
    brew install --cask mactex || {
        echo "Failed to install MacTeX"
        exit 1
    }
    brew install --cask lyx || {
        echo "Failed to install LyX"
        exit 1
    }

    echo "Installing Culmus fonts..."
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    if ! curl -L -O https://sourceforge.net/projects/culmus/files/culmus/0.133/culmus-0.133.tar.gz; then
        echo "Failed to download Culmus fonts"
        rm -rf "$temp_dir"
        exit 1
    fi

    tar -xf culmus-0.133.tar.gz
    cd culmus-0.133
    cp -a . /Library/Fonts/
    cd ..
    rm -rf "$temp_dir"

    echo "Fonts installed successfully"
}

# Function to install LyX with preferences and settings
install_settings() {
    # Detect LyX version and set paths accordingly
    local lyx_version="2.4" # Default version
    local lyx_support_dir="$HOME/Library/Application Support/LyX-$lyx_version"

    # Create necessary directories
    mkdir -p "$lyx_support_dir/templates" || {
        echo "Failed to create LyX directories"
        exit 1
    }

    # Create preferences file
    echo "Creating preferences file..."
    cat >"$lyx_support_dir/preferences" <<'EOF'
Format 24


#
# MISC SECTION ######################################
#

\\kbmap true
\\kbmap_primary "american"
\\kbmap_secondary "hebrew"
\\user_name ""
\\user_email ""

#
# SCREEN & FONTS SECTION ############################
#


#
# COLOR SECTION ###################################
#


#
# PRINTER SECTION ###################################
#


#
# TEX SECTION #######################################
#


#
# FILE SECTION ######################################
#


#
# PLAIN TEXT EXPORT SECTION ##############################
#


#
# SPELLCHECKER SECTION ##############################
#

\\use_system_colors false

#
# LANGUAGE SUPPORT SECTION ##########################
#

\\visual_cursor true
\\mark_foreign_language false

#
# 2nd MISC SUPPORT SECTION ##########################
#


#
# FORMATS SECTION ##########################
#


#
# CONVERTERS SECTION ##########################
#


#
# COPIERS SECTION ##########################
#
EOF

    echo "Creating default template..."
    cat >"$lyx_support_dir/templates/defaults.lyx" <<'EOF'
\\lyxformat 544
\\begin_document
\\begin_header
\\save_transient_properties true
\\origin unavailable
\\textclass article
\\use_default_options true
\\maintain_unincluded_children false
\\language hebrew
\\language_package default
\\inputencoding auto
\\fontencoding global
\\font_roman "default" "David CLM"
\\font_sans "default" "Simple CLM"
\\font_typewriter "default" "Miriam CLM"
\\font_math "auto" "auto"
\\font_default_family default
\\use_non_tex_fonts true
\\font_sc false
\\font_osf false
\\font_sf_scale 100 100
\\font_tt_scale 100 100
\\use_microtype false
\\use_dash_ligatures true
\\graphics default
\\default_output_format default
\\output_sync 0
\\bibtex_command default
\\index_command default
\\paperfontsize default
\\spacing single
\\use_hyperref false
\\papersize default
\\use_geometry true
\\use_package amsmath 1
\\use_package amssymb 1
\\use_package cancel 1
\\use_package esint 1
\\use_package mathdots 1
\\use_package mathtools 1
\\use_package mhchem 1
\\use_package stackrel 1
\\use_package stmaryrd 1
\\use_package undertilde 1
\\cite_engine basic
\\cite_engine_type default
\\biblio_style plain
\\use_bibtopic false
\\use_indices false
\\paperorientation portrait
\\suppress_date false
\\justification true
\\use_refstyle 0
\\use_minted 0
\\index Index
\\shortcut idx
\\color #008000
\\end_index
\\secnumdepth 3
\\tocdepth 3
\\paragraph_separation indent
\\paragraph_indentation default
\\is_math_indent 0
\\math_numbering_side default
\\quotes_style english
\\dynamic_quotes 0
\\papercolumns 1
\\papersides 1
\\paperpagestyle default
\\bullet 0 2 5 -1
\\tracking_changes false
\\output_changes false
\\html_math_output 0
\\html_css_as_file 0
\\html_be_strict false
\\end_header

\\begin_body

\\begin_layout Standard

\\end_layout

\\end_body
\\end_document
EOF

    echo "Settings installed successfully!"
}

# Main script execution
case "$1" in 
    --only-settings)
        install_settings
        ;;
    --with-settings)
        install
        install_settings
        ;;
    --without-settings)
        install
        ;;
    *)
        echo "Usage: $0 [--with-settings | --without-settings | --only-settings]"
        ;;
esac
