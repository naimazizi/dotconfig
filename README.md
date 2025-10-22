# personal .config repo

## List of configs

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

## Requirements

- homebrew (for macos)

## Installation

```{bash}
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/naimazizi/dotconfig .

brew install \
  lsd \
  fd \
  pyenv \
  pyenv-virtualenv \
  node \
  neovim \
  neovide \
  gitui \
  lazygit \
  direnv \
  fzf \
  bat \
  ripgrep \
  zoxide \
  delta \
  sk \
  gh \
  zellij

mkdir -p ~/Applications
brew install --cask ghostty font-maple-mono --appdir=~/Applications
```
