To add new dotfile files and directories, you can either:

1. Edit the script directly by adding to the arrays:
```zsh
# In setup-dotfiles.zsh
DOTFILE_DIRS=(
    .cache
    .conda
    .config
    .cursor
    .docker
    .gk
    .scripts
    .ssh
    .tmp
    .zsh_sessions
    # .new-directory    # Add new directory here
)

DOTFILE_FILES=(
    .Brewfile
    .condarc
    .gitconfig
    .gitignore
    .zprofile
    .zshrc
    # .new-file        # Add new file here
)
```

2. Or, since your dotfiles are now managed in the `~/.dotfiles` directory, you can manage them directly:

For a new file:
```zsh
# 1. Create the file in .dotfiles
cd ~/.dotfiles
touch .mynewrc

# 2. Create the symlink
ln -s ~/.dotfiles/.mynewrc ~/.mynewrc

# 3. Add to git (optional)
git add .mynewrc
git commit -m "Add .mynewrc"
```

For a new directory:
```zsh
# 1. Create the directory in .dotfiles
cd ~/.dotfiles
mkdir .newconfig

# 2. Create the symlink
ln -s ~/.dotfiles/.newconfig ~/.newconfig

# 3. Add to git (optional)
git add .newconfig
git commit -m "Add .newconfig directory"
```
