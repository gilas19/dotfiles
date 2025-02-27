alias cask="brew install --cask"
alias brewup="brew update && brew upgrade && brew cleanup --prune=all && brew autoremove && brew doctor"
alias cleanup="sudo rm -rf ~/Library/Caches/* && sudo rm -rf ~/Library/Logs/* && sudo rm -rf ~/Library/Containers/com.docker.docker/Data/* && defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock"
alias yadmup="yadm pull && brew bundle dump --force --file=~/.config/brew/Brewfile && yadm commit -a -m 'Update dotfiles' && yadm push"