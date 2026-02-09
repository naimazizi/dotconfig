# personal .config repo

## List of configs

- atuin
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
  atuin \
  bat \
  delta \
  direnv \
  fd \
  fzf \
  gh \
  hurl \
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
brew install --cask ghostty font-monaspace-nf --appdir=~/Applications
```
