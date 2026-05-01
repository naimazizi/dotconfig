ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Force Emacs style inside neovim terminal
if [[ -n $NVIM ]]; then
	bindkey -e
fi

# fpath config - load early for plugin functions
fpath+=${ZDOTDIR}/.zfunc
autoload -Uz fzg

# Additional Config
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases
alias ls='lsd'
alias ll="lsd -ltr"
alias find='fd'
alias gg='lazygit'
alias vv='nvim'
alias nvim_update='nvim --headless "+Lazy! sync" +qa'
alias neovide_remote="neovide --neovim-bin ~/.config/nvim-remote.sh"
alias ls_arch_packages="pacman -Qi | grep -E '^(Name|Installed)' | cut -f2 -d':' | paste - - | column -t | sort -nrk 2 | grep MiB | less"
alias ss="zsh $HOME/.config/skim_search.sh"
alias zz="zoxide query -i"

# Consolidated PATH construction for better performance
# Build PATH array with deduplication instead of repeated concatenations
typeset -U PATH_DIRS
PATH_DIRS=(
	"/usr/local/bin"
	"$HOME/.local/bin"
	"/opt/google-cloud-cli/bin"
	"$HOME/.local/share/nvim/mason/bin"
	"$HOME/.bun/bin"
	"$HOME/.rd/bin"
	"$HOME/.cargo/bin"
	"$HOME/.local/share/bob/nvim-bin"
	"$HOME/.pyenv/bin"
	"$HOME/.local/share/bob"
)

for dir in "${PATH_DIRS[@]}"; do
	[[ -d "$dir" ]] && PATH="$dir:$PATH"
done
export PATH # Single export instead of per-loop exports

# Homebrew setup (prefer macOS)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
	export HOMEBREW_PREFIX='/opt/homebrew'
	export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
	export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/homebrew"
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
	export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
	export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Pyenv - lazy init only if used
if command -v pyenv &>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	eval "$(pyenv init - zsh)"
	eval "$(pyenv virtualenv-init -)"
fi

# Smart insert prefix options (fzf menu)
export ZSH_SMART_INSERT_PREFIXES="nvim:bat:code"
export ZSH_SMART_INSERT_IGNOREDIRS=".git/*:node_modules/:dist/:.venv/"

# autosuggestions and completion
zinit wait lucid light-mode for \
	atload"_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions \
	blockf atpull'zinit creinstall -q .' \
	zsh-users/zsh-completions

# syntax highlighting
zinit ice as"program" from"gh-r" pick"zsh-patina-*/zsh-patina" atload'eval "$(zsh-patina activate)"'
zinit light michel-kraemer/zsh-patina

# starship
zinit ice as"command" from"gh-r" \
	atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
	atpull"%atclone" src"init.zsh"
zinit light starship/starship

# zoxide
zinit ice lucid wait="0"
zinit snippet https://github.com/ajeetdsouza/zoxide/blob/main/zoxide.plugin.zsh

# direnv
zinit from"gh-r" as"program" mv"direnv* -> direnv" \
	atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
	pick"direnv" src="zhook.zsh" for \
	direnv/direnv

eval "$(direnv hook zsh)"

# SSH
zinit light sunlei/zsh-ssh

# Atuin initialization
eval "$(atuin init zsh)"

# fzf-tab
autoload -Uz compinit
compinit
zinit light Aloxaf/fzf-tab
