# ZIM Configuration
ZIM_CONFIG_FILE=~/.config/zsh/.zimrc
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
	curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
		https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
	source ${ZIM_HOME}/zimfw.zsh init
fi

# Load zim
source ${ZIM_HOME}/init.zsh

# fpath config
fpath+=${ZDOTDIR}/.zfunc

# Load function from fpath or any zsh function
autoload -Uz fzg
autoload -Uz edit-command-line
zle -N edit-command-linej

# Aliases
alias ls='lsd'
alias ll="lsd -ltr"
alias find='fd'
alias ai='gh copilot'
alias dev="limactl shell lima-box fish"
alias nvim_remote="limactl shell lima-box nvim"
alias nvim_update='nvim --headless "+Lazy! sync" +qa'
alias neovide_remote="neovide --neovim-bin ~/.config/nvim-remote.sh"
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
alias ls_arch_packages="pacman -Qi | grep -E '^(Name|Installed)' | cut -f2 -d':' | paste - - | column -t | sort -nrk 2 | grep MiB | less"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
	export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init - zsh)"
  eval "$(pyenv virtualenv-init -)"
fi

# Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then # MacOS
	export HOMEBREW_PREFIX='/opt/homebrew'
	export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
	export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/homebrew"
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then # Linux
	export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
	export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
	export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Bob (Nvim)
BOB_PATH="$HOME/.local/share/bob/nvim-bin"
if [[ -f "${BOB_PATH}/nvim" ]]; then
	export PATH=$PATH:$BOB_PATH
fi

# Cargo (rust)
CARGO_PATH="$HOME/.cargo/bin"
if [[ -d "${CARGO_PATH}" ]]; then
	export PATH=$PATH:$CARGO_PATH
fi

# Rancher Desktop
RANCHER_PATH="$HOME/.rd/bin"
if [[ -d "${RANCHER_PATH}" ]]; then
	export PATH=$PATH:$RANCHER_PATH
fi

# Exclude failed history
zshaddhistory() {
   local j=1
   while ([[ ${${(z)1}[$j]} == *=* ]]) {
     ((j++))
   }
   whence ${${(z)1}[$j]} >| /dev/null || return 1
 }

# Environment variables
if command -v nvim &>/dev/null; then
	export EDITOR='nvim'
	export VISUAL='nvim'
else
	export EDITOR='vim'
	export VISUAL='vim'
fi

# Plugin

# Vi mode
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
function zvm_after_lazy_keybindings() {
	bindkey -M vicmd 'vv' edit-command-line
}

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
