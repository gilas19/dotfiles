#!/usr/bin/env zsh

# Configuration
DOTFILES_DIR="${HOME}/.dotfiles"
BACKUP_DIR="${DOTFILES_DIR}/backup/$(date +%Y%m%d_%H%M%S)"
# CONFIG_FILE="${DOTFILES_DIR}/dotfiles.yaml"

# Define directories to manage
DOTFILE_DIRS=(
    .cache
    .conda
    .config
    .docker
    .gk
    .scripts
    .ssh
    .tmp
    .zsh_sessions
)

# Define files to manage
DOTFILE_FILES=(
    .Brewfile
    .condarc
    .gitconfig
    .gitignore
    .zprofile
    .zshrc
)

# Function to setup Homebrew
setup_homebrew() {
    echo "\nChecking Homebrew setup..."
    
    # Install Homebrew if it's not installed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed"
    fi
    
    # Ensure Homebrew is in PATH (M1 Macs might need this)
    if [[ "$(arch)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

setup_homebrew

install_packages() {
    # Update Homebrew
    echo "Updating Homebrew..."
    brew update
    
    # Check if Brewfile exists
    if [[ -f "${HOME}/.config/brew/Brewfile" ]]; then
        echo "Found Brewfile, installing packages..."
        # Use brew bundle with custom Brewfile location
        brew bundle --file="${HOME}/.config/brew/Brewfile"
    else
        echo "No Brewfile found at ~/.config/brew/Brewfile"
    fi
}

install_packages


# Create necessary directories
mkdir -p "${DOTFILES_DIR}"
mkdir -p "${BACKUP_DIR}"

# Function to backup existing item
backup_item() {
    local item="$1"
    if [[ -e "${HOME}/${item}" && ! -L "${HOME}/${item}" ]]; then
        echo "Backing up ${item}"
        cp -R "${HOME}/${item}" "${BACKUP_DIR}/"
    fi
}

# Function to create symlink
create_symlink() {
    local item="$1"
    if [[ ! -L "${HOME}/${item}" ]]; then
        echo "Creating symlink for ${item}"
        ln -sfn "${DOTFILES_DIR}/${item}" "${HOME}/${item}"
    fi
}

# Function to initialize git repository
init_git_repo() {
    if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
        echo "Initializing git repository"
        cd "${DOTFILES_DIR}"
        cat >.gitignore <<EOL
.DS_Store
*.log
backup/
.cache/
.tmp/
.zsh_sessions/
.zsh_history
*.zwc
*.zwc.old
EOL
        git init
        git add .gitignore
        git commit -m "Initial commit"
    fi
}

# Function to handle directory migration
handle_directory() {
    local dir="$1"
    # Skip if it's a symlink already
    if [[ -L "${HOME}/${dir}" ]]; then
        echo "Directory ${dir} is already managed"
        return
    fi

    # If directory exists in home but not in dotfiles, move it
    if [[ -d "${HOME}/${dir}" && ! -d "${DOTFILES_DIR}/${dir}" ]]; then
        echo "Moving ${dir} to dotfiles directory"
        mv "${HOME}/${dir}" "${DOTFILES_DIR}/"
    elif [[ ! -d "${DOTFILES_DIR}/${dir}" ]]; then
        # Create empty directory if it doesn't exist
        mkdir -p "${DOTFILES_DIR}/${dir}"
    fi

    # Create symlink
    create_symlink "${dir}"
}

# Function to handle file migration
handle_file() {
    local file="$1"
    # Skip if it's a symlink already
    if [[ -L "${HOME}/${file}" ]]; then
        echo "File ${file} is already managed"
        return
    fi

    # If file exists in home but not in dotfiles, move it
    if [[ -f "${HOME}/${file}" && ! -f "${DOTFILES_DIR}/${file}" ]]; then
        echo "Moving ${file} to dotfiles directory"
        mv "${HOME}/${file}" "${DOTFILES_DIR}/"
    fi

    # Create symlink
    create_symlink "${file}"
}

# Main script
echo "Setting up dotfiles..."

# Initialize git repository
init_git_repo

# Process directories
echo "\nProcessing directories..."
for dir in ${DOTFILE_DIRS[@]}; do
    if [[ "${dir}" == ".ssh" ]]; then
        echo "Skipping .ssh directory for security (manage manually)"
        continue
    fi

    # Backup existing directory
    backup_item "${dir}"

    # Handle directory
    handle_directory "${dir}"
done

# Process files
echo "\nProcessing files..."
for file in ${DOTFILE_FILES[@]}; do
    # Skip .zsh_history as it's dynamic
    if [[ "${file}" == ".zsh_history" ]]; then
        continue
    fi

    # Backup existing file
    backup_item "${file}"

    # Handle file
    handle_file "${file}"
done

# Setup Homebrew and install packages
setup_homebrew

# Special handling for sensitive directories
echo "\nNote: The following items require manual management:"
echo "- .ssh directory (for security)"
echo "- .zsh_history (dynamic file)"

echo "\nDotfiles setup complete!"
echo "Your dotfiles are now managed in ${DOTFILES_DIR}"
echo "Backups were created in ${BACKUP_DIR}"
echo "\nImportant notes:"
echo "1. Review the contents of ${DOTFILES_DIR} to ensure everything was moved correctly"
echo "2. Some directories like .cache and .tmp may contain machine-specific data"
echo "3. The .ssh directory was skipped for security - manage it manually if needed"
echo "4. Use git in ${DOTFILES_DIR} to version control your configurations"
