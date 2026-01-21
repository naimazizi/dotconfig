# ZIM Configuration
ZIM_CONFIG_FILE=~/.config/zsh/.zimrc
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Additional Config
ZVM_MAN_PAGER='less'
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

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
zle -N edit-command-line

# Aliases
alias ls='lsd'
alias ll="lsd -ltr"
alias find='fd'
alias gg='lazygit'
alias vv='nvim'
alias nvim_update='nvim --headless "+Lazy! sync" +qa'
alias neovide_remote="neovide --neovim-bin ~/.config/nvim-remote.sh"
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
alias ls_arch_packages="pacman -Qi | grep -E '^(Name|Installed)' | cut -f2 -d':' | paste - - | column -t | sort -nrk 2 | grep MiB | less"
alias ss="zsh $HOME/.config/skim_search.sh"

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
if [[ -d "${BOB_PATH}" ]]; then
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

# Bun
export BUN_PATH="$HOME/.bun/bin"
if [[ -d "${BUN_PATH}" ]]; then
  export PATH=$PATH:$BUN_PATH
fi

# Mason bin
export MASON_BIN_PATH="$HOME/.local/share/nvim/mason/bin"
if [[ -d "${MASON_BIN_PATH}" ]]; then
  export PATH=$PATH:$MASON_BIN_PATH
fi

# local bin
export LOCAL_BIN_PATH="$HOME/.local/bin"
if [[ -d "${LOCAL_BIN_PATH}" ]]; then
  export PATH=$PATH:$LOCAL_BIN_PATH
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

# Plugin
eval "$(atuin init zsh)"

# Vi mode
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
function zvm_after_lazy_keybindings() {
  bindkey -M vicmd 'vv' edit-command-line
}

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
