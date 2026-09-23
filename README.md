# personal .config repo

## List of configs

- amethyst
- atuin
- fish
- ghostty
- gitui
- helix
- herdr
- kitty
- lazygit
- neovim
- opencode
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

```bash
mkdir -p ~/.config

if [ ! -d ~/.config/.git ]; then
  git -C ~/.config init
  git -C ~/.config remote add origin git@github.com:naimazizi/dotconfig.git
fi

git -C ~/.config pull --ff-only origin main

brew install \
  atuin \
  bat \
  bob \
  delta \
  direnv \
  fd \
  fzf \
  gh \
  herdr \
  hurl \
  just \
  lazygit \
  lsd \
  node \
  ripgrep \
  sk \
  tmuxinator \
  tree-sitter-cli \
  yazi \
  uv \
  rustup \
  z \
  zellij \
  zoxide

mkdir -p ~/Applications
brew install --cask ghostty font-monaspace-nf --appdir=~/Applications
brew install alchemmist/tap/lazy-tmux
brew install iwe-org/iwe/iwe


# Agent skill
npx skills add iwe-org/skills

# Yazi plugins
xargs ya pkg add < ~/.config/yazi/plugins.txt

# Herdr plugins
xargs -I{} herdr plugin install {} --yes < ~/.config/herdr/plugins.txt
```

## MacOS Specifics

- Amethyst

```text {bash}
ln -s "~/.config/amethyst/Layouts/center_or_tall.js" "~/Library/Application Support/Amethyst/Layouts/center_or_tall.js
```
