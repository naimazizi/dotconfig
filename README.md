# personal .config repo

## List of configs

- fish
- ghostty
- gitui
- helix
- hypr (abandoned)
- kitty
- lazygit
- neovide
- neovim
- niri
- opencode
- television
- tmux
- tmuxinator
- vim
- vscode (theme)
- wezterm
- yazi
- zed
- zellij
- zsh

## Requirements

- homebrew (for macos & linux)

## Installation

```{bash}
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/naimazizi/dotconfig .

brew install \
  bat \
  delta \
  direnv \
  fd \
  fzf \
  gh \
  just \
  lazygit \
  lsd \
  neovide \
  neovim \
  node \
  opencode \
  pyenv \
  pyenv-virtualenv \
  ripgrep \
  sk \
  tmuxinator \
  tree-sitter-cli \
  z \
  zellij \
  zoxide

mkdir -p ~/Applications
brew install --cask ghostty font-maple-mono-nf --appdir=~/Applications
```
