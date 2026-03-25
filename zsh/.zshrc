ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# fpath config - load early for plugin functions
fpath+=${ZDOTDIR}/.zfunc
autoload -Uz fzg

# Additional Config
ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# Aliases
alias ls='lsd'
alias ll="lsd -ltr"
alias find='fd'
alias gg='gitui'
alias vv='nvim'
alias nvim_update='nvim --headless "+Lazy! sync" +qa'
alias neovide_remote="neovide --neovim-bin ~/.config/nvim-remote.sh"
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
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

# Environment variables
if command -v nvim &>/dev/null; then
	export EDITOR='nvim'
	export VISUAL='nvim'
	export ZVM_VI_EDITOR='nvim'
else
	export EDITOR='vim'
	export VISUAL='vim'
	export ZVM_VI_EDITOR='vim'
fi

# Smart insert prefix options (fzf menu)
export ZSH_SMART_INSERT_PREFIXES="nvim:bat:code"
export ZSH_SMART_INSERT_IGNOREDIRS=".git/*:node_modules/:dist/:.venv/"

# Vi mode keybindings
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
function zvm_after_lazy_keybindings() {
	bindkey -M vicmd 'vv' edit-command-line
}

# autosuggestions and completion
zinit wait lucid light-mode for \
	atinit"zicompinit; zicdreplay" \
	zdharma-continuum/fast-syntax-highlighting \
	atload"_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions \
	blockf atpull'zinit creinstall -q .' \
	zsh-users/zsh-completions

# Atuin initialization
zinit ice as"command" from"gh-r" bpick"atuin-*.tar.gz" \
	mv"atuin*/atuin -> atuin" \
	atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
	atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin

# Vi-mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# starship
zinit ice as"command" from"gh-r" \
	atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
	atpull"%atclone" src"init.zsh"
zinit light starship/starship

# zoxide
zinit ice lucid wait="0"
zinit snippet https://github.com/ajeetdsouza/zoxide/blob/main/zoxide.plugin.zsh

# fzf-tab
zinit light Aloxaf/fzf-tab

# direnv
zinit from"gh-r" as"program" mv"direnv* -> direnv" \
	atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
	pick"direnv" src="zhook.zsh" for \
	direnv/direnv

# smart insert
zinit light lgdevlop/zsh-smart-insert

# SSH
zinit light sunlei/zsh-ssh
