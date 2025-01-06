# Homebrew environment setup - needed for interactive shell commands
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load aliases
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh
