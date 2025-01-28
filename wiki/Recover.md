Here's how to recover your dotfiles in different scenarios:

1. If you want to clone your dotfiles to a new machine:

```zsh
# 1. Clone your dotfiles repository
git clone <your-repo-url> ~/.dotfiles

# 2. Run the setup script
cd ~/.dotfiles
./setup-dotfiles.zsh
```

2. If you want to restore from the backup created by the setup script:

```zsh
# List available backups
ls ~/.dotfiles/backup/

# Restore specific files/directories from a backup
cp -r ~/.dotfiles/backup/YYYYMMDD_HHMMSS/<file> ~/
```

3. Recovery script that can help restore everything.
   
    To use the recovery script:

```zsh
# Run the recovery script
./recover-dotfiles.zsh
```

The script provides three options:

1. List available backups
2. Restore from a specific backup
3. Restore from git repository (useful when setting up a new machine)

Some additional recovery tips:

1. If you just want to restore a single file:
```zsh
# From git
git checkout path/to/file

# From backup
cp ~/.dotfiles/backup/YYYYMMDD_HHMMSS/file ~/
```

2. If you want to check what's different:
```zsh
# For git-managed files
cd ~/.dotfiles
git status
git diff

# For backup files
diff ~/.dotfiles/backup/YYYYMMDD_HHMMSS/file ~/file
```
