# personal .config repo

## List of configs

- amethyst
- atuin
- claude
- fish
- ghostty
- gitui
- helix
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
- zed
- zellij
- zsh

## Requirements

- homebrew (for macos & linux)

## Installation

```text {bash}
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/naimazizi/dotconfig .

brew tap ojuschugh1/sqz

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
  micromamba \
  neovide \
  neovim \
  node \
  opencode \
  ripgrep \
  sk \
  sqz \
  tmuxinator \
  tree-sitter-cli \
  yazi \
  z \
  zellij \
  zoxide

mkdir -p ~/Applications
brew install --cask ghostty font-monaspace-nf --appdir=~/Applications
brew install alchemmist/tap/lazy-tmux
```

## MacOS Specifics

- Amethyst

```text {bash}
ln -s "~/.config/amethyst/Layouts/center_or_tall.js" "~/Library/Application Support/Amethyst/Layouts/center_or_tall.js
```
