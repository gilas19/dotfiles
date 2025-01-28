#!/usr/bin/env zsh

# Configuration
DOTFILES_DIR="${HOME}/.dotfiles"

# Function to list available backups
list_backups() {
    echo "Available backups:"
    ls -l "${DOTFILES_DIR}/backup/"
}

# Function to restore from a specific backup
restore_from_backup() {
    local backup_dir="$1"

    if [[ ! -d "${DOTFILES_DIR}/backup/${backup_dir}" ]]; then
        echo "Backup directory not found: ${backup_dir}"
        return 1
    fi

    echo "Restoring from backup: ${backup_dir}"

    # Remove existing symlinks
    for item in "${DOTFILES_DIR}"/.*; do
        local base_name=$(basename "$item")
        if [[ -L "${HOME}/${base_name}" ]]; then
            echo "Removing symlink: ${HOME}/${base_name}"
            rm "${HOME}/${base_name}"
        fi
    done

    # Restore from backup
    echo "Copying files from backup..."
    cp -R "${DOTFILES_DIR}/backup/${backup_dir}"/. "${HOME}/"

    echo "Backup restored!"
}

# Function to restore from git repository
restore_from_git() {
    if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
        echo "Error: ${DOTFILES_DIR} is not a git repository"
        return 1
    fi

    echo "Restoring from git repository..."

    # Reset any local changes
    cd "${DOTFILES_DIR}"
    git reset --hard
    git clean -fd

    # Pull latest changes
    git pull

    # Create symlinks
    for item in "${DOTFILES_DIR}"/.*; do
        local base_name=$(basename "$item")
        # Skip . and .. and git directory
        if [[ "${base_name}" == "." || "${base_name}" == ".." || "${base_name}" == ".git" ]]; then
            continue
        fi

        # Remove existing symlink or file
        if [[ -e "${HOME}/${base_name}" ]]; then
            echo "Removing existing: ${HOME}/${base_name}"
            rm -rf "${HOME}/${base_name}"
        fi

        # Create new symlink
        echo "Creating symlink: ${base_name}"
        ln -s "${DOTFILES_DIR}/${base_name}" "${HOME}/${base_name}"
    done

    echo "Git repository restored and symlinks created!"
}

# Main menu
echo "Dotfiles Recovery"
echo "1. List available backups"
echo "2. Restore from backup"
echo "3. Restore from git repository"
echo "4. Exit"

read "choice?Choose an option (1-4): "

case $choice in
1)
    list_backups
    ;;
2)
    list_backups
    echo ""
    read "backup_dir?Enter backup directory name to restore from: "
    restore_from_backup "$backup_dir"
    ;;
3)
    restore_from_git
    ;;
4)
    echo "Exiting..."
    exit 0
    ;;
*)
    echo "Invalid option"
    exit 1
    ;;
esac
