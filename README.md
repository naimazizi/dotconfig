# personal .config repo

## List of configs:
- fish
- ghostty
- gitui
- helix
- neovim
- television
- vscode (theme)
- wezterm
- yazi
- zed
- zellij

## Requirements :
- homebrew (for macos)

## Installation

```{bash}
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/naimazizi/dotconfig .

brew install \
  fish \
  lsd \
  fd \
  pyenv \
  pyenv-virtualenv \
  node \
  neovim \
  gitui \
  fzf \
  bat \
  ripgrep \
  zoxide \

mkdir -p ~/Applications
brew install --cask ghostty font-jetbrains-maple-mono-nf --appdir=~/Applications
```
