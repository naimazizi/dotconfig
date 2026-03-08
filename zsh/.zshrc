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
alias gg='gitui'
alias vv='nvim'
alias nvim_update='nvim --headless "+Lazy! sync" +qa'
alias neovide_remote="neovide --neovim-bin ~/.config/nvim-remote.sh"
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
alias ls_arch_packages="pacman -Qi | grep -E '^(Name|Installed)' | cut -f2 -d':' | paste - - | column -t | sort -nrk 2 | grep MiB | less"
alias ss="zsh $HOME/.config/skim_search.sh"

# Consolidated PATH construction for better performance
# Build PATH array instead of repeated $PATH:$X concatenations
typeset -U PATH_DIRS
PATH_DIRS=(
  "$HOME/.local/bin"
  "/opt/google-cloud-cli/bin"
  "$HOME/.local/share/nvim/mason/bin"
  "$HOME/.bun/bin"
  "$HOME/.rd/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/share/bob/nvim-bin"
  "$HOME/.pyenv/bin"
)

for dir in "${PATH_DIRS[@]}"; do
  [[ -d "$dir" ]] && export PATH="$dir:$PATH"
done

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

# Pyenv 
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &>/dev/null; then
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

# Plugin initialization
# Zoxide is fast enough to load normally
eval "$(zoxide init zsh)"

# Lazy load atuin - slow command history
function _init_atuin() {
  eval "$(atuin init zsh)"
  # Replace function with noop after first call
  _init_atuin() { :; }
}
# Intercept common history commands
alias history='_init_atuin && history'
alias h='_init_atuin && history'

# Vi mode
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
function zvm_after_lazy_keybindings() {
  bindkey -M vicmd 'vv' edit-command-line
}

zmodload -F zsh/terminfo +p:terminfo 2>/dev/null
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
