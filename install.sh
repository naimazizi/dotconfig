#!/bin/bash
# Dotfiles install script for GitHub Codespaces
# Symlinks selected configs from ~/dotfiles into ~/.config/

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${HOME}/.config"

# Configs to symlink
CONFIGS=(
	fish
	zsh
	nvim
	tmux
	tmuxinator
	starship.toml
	lazygit
	opencode
	yazi
	zellij
)

mkdir -p "$CONFIG_DIR"

for item in "${CONFIGS[@]}"; do
	src="$DOTFILES_DIR/$item"
	dest="$CONFIG_DIR/$item"

	if [ ! -e "$src" ]; then
		echo "SKIP: $item (not found in dotfiles)"
		continue
	fi

	# Back up existing non-symlink targets
	if [ -e "$dest" ] && [ ! -L "$dest" ]; then
		echo "BACKUP: $dest -> $dest.bak"
		mv "$dest" "$dest.bak"
	fi

	# Remove existing symlink
	[ -L "$dest" ] && rm "$dest"

	ln -s "$src" "$dest"
	echo "LINK: $dest -> $src"
done

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install tools
echo "Installing tools via Homebrew..."
brew install \
	atuin \
	bat \
	delta \
	direnv \
	fd \
	fzf \
	gh \
	lazygit \
	lsd \
	neovim \
	node \
	pyenv \
	pyenv-virtualenv \
	ripgrep \
	sk \
	starship \
	tmux \
	tmuxinator \
	tree-sitter-cli \
	yazi \
	z \
	zellij \
	zoxide \
	uv

echo "Dotfiles installation complete!"
