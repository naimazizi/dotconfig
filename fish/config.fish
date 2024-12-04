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

if type -q micromamba
    eval "$(micromamba shell hook --shell fish)"
end

alias ls='lsd'
alias ll="lsd -ltr"
alias find='fd'
alias ai='gh copilot'
alias dbtx='FINSERV_ETL_DEV_BQ_DATASET=naim_azizi dbt --profiles-dir profiles/'

set RG_PREFIX "rg --column --line-number --no-heading --color=always --smart-case "
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# Kanagawa Theme
## Kanagawa Paper Fish shell theme
set -l foreground DCD7BA normal
set -l selection 658594 brcyan
set -l comment a6a69c brblack
set -l red c4746e red
set -l orange b6927b brred
set -l yellow c4b28a yellow
set -l green 8a9a7b green
set -l purple a292a3 magenta
set -l cyan 8ea4a2 cyan
set -l pink D27E99 brmagenta

## Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

## Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# Created by `pipx` on 2024-12-03 14:54:48
set PATH $PATH ~/.local/bin
