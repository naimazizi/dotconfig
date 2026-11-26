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
- pi-coding-agent
- tmux
- tmuxinator
- vim
- vscode (theme)
- wezterm
- zed
- zellij
- zsh
- vscodium

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
    pi-coding-agent \
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
brew tap 1jehuang/mmdr && brew install mmdr
brew tap dondai44423/donsetch && brew install donsetch

# Agent skill
npx skills add iwe-org/skills --skill graph -g
npx skills add tt-a1i/archify -g

# Playwright CLI and agent skills
npm install -g @playwright/cli@latest
playwright-cli install --skills=agents

# Serena for Pi
uv tool install -p 3.13 serena-agent

# Yazi plugins
xargs ya pkg add <~/.config/yazi/plugins.txt

# Herdr plugins
xargs -I{} herdr plugin install {} --yes <~/.config/herdr/plugins.txt
```

# VScodium (Sync setting)

```yaml
profile: main
repository:
    type: file
    path: ~/.config/vscodium
```

## MacOS Specifics

- Amethyst

```text {bash}
ln -s "~/.config/amethyst/Layouts/center_or_tall.js" "~/Library/Application Support/Amethyst/Layouts/center_or_tall.js
```

## OpenSpec and Plannotator

Install the CLIs on macOS or Linux:

```bash
brew install openspec
curl -fsSL https://plannotator.ai/install.sh | bash

openspec --version
plannotator --version
```

Initialize OpenSpec in each project and select Pi when prompted:

```bash
cd /path/to/project
openspec init
```

Create and review a change in Pi-Bolt:

```text
/skill:openspec-propose Describe the change
/openspec-review <change-name>
```

`/openspec-review` opens the change artifacts in Plannotator on request.
After review, run `/skill:openspec-apply-change <change-name>` to implement the tasks, then `/skill:openspec-archive-change <change-name>` when the work is complete.
The Plannotator Pi extension is listed in `pi/settings.json`; its standalone CLI and extension are separate installations.
