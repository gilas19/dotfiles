#!/usr/bin/env zsh
# created by gilad ticher

# This script installs LyX with hebrew Fonts on macOS using Homebrew.
# It also creates a preferences file for LyX settings.
# Lyx setting works only with LyX version 2.3 and above.

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Install Homebrew First!"
else
    echo "Homebrew is already installed."
fi

# Function to install LyX without preferences and settings
Install() {
    # Install MacTeX and LyX using Homebrew
    brew install --cask mactex
    brew install --cask lyx

    # Install Culmus fonts
    mkdir tex_temp
    cd tex_temp
    curl -O https://sourceforge.net/projects/culmus/files/culmus/0.133/culmus-0.133.tar.gz
    tar -xvf culmus-0.133.tar.gz
    cd culmus-0.133         # Change into the extracted directory
    cp -a . /Library/Fonts/ # Copy all the fonts into the system fonts directory
    cd ../..
    rm -rf tex_temp
}

# Function to install LyX with preferences and settings
install_settings() {
    # Create preferences file for LyX settings
    cat <<EOF >~/Library/Application\ Support/LyX-2.3/preferences
# LyX 2.3.7 generated this file. If you want to make your own
# modifications you should do them from inside LyX and save.

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

    echo "File 'preferences' generated successfully!"

    # Create defaults.lyx file for LyX settings
    mkdir -p ~/Library/Application\ Support/LyX-2.3/templates
    cat <<EOF >~/Library/Application\ Support/LyX-2.3/templates/defaults.lyx
#LyX 2.3 created this file. For more info see http://www.lyx.org/
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

    echo "File 'defaults.lyx' generated successfully!"
}

# Check command-line argument
if [ "$1" == "--only-settings" ]; then
    install_settings
elif [ "$1" == "--with-settings" ]; then
    Install
    install_settings
elif [ "$1" == "--without-settings" ]; then
    Install
else
    echo "Usage: $0 [--with-settings | --without-settings | --only-settings]"
fi
