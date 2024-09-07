if test -d /home/linuxbrew/.linuxbrew # Linux
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
    set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
else if test -d /opt/homebrew # MacOS
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
    set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
end
fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
! set -q MANPATH; and set MANPATH ''
set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH
! set -q INFOPATH; and set INFOPATH ''
set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

fish_add_path ~/.cargo/bin

set -gx HOMEBREW_CASK_OPTS "--appdir=~/Applications"
set -x GPG_TTY (tty)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/mambaforge/base/bin/conda
    eval /opt/homebrew/Caskroom/mambaforge/base/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/opt/homebrew/Caskroom/mambaforge/base/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/Caskroom/mambaforge/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /opt/homebrew/Caskroom/mambaforge/base/bin $PATH
    end
end

if test -f "/opt/homebrew/Caskroom/mambaforge/base/etc/fish/conf.d/mamba.fish"
    source "/opt/homebrew/Caskroom/mambaforge/base/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<

alias ls='lsd'
alias ll="lsd -ltr"
alias find='fd'
alias ai='gh copilot'
alias dbtx='FINSERV_ETL_DEV_BQ_DATASET=naim_azizi dbt --profiles-dir profiles/'

set RG_PREFIX "rg --column --line-number --no-heading --color=always --smart-case "
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
