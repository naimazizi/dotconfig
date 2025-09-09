# ZIM Configuration
ZIM_CONFIG_FILE=~/.config/zsh/.zimrc
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Environment variables
export ALIEN_USE_NERD_FONT=1
export ALIEN_THEME="gruvbox"

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# fpath config
fpath+=${ZDOTDIR}/.zfunc

# Load funtion from fpath or any zsh function
autoload -Uz fzg

source ${ZIM_HOME}/init.zsh

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

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Bob (Nvim)
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin
