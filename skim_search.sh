#!/usr/bin/env bash

# Set default editor to $VISUAL, fallback to nvim
EDITOR="${VISUAL:-nvim}"

# Check if bat is available, else use cat
if command -v bat &>/dev/null; then
  PREVIEW_CMD='bat --style=numbers --color=always --highlight-line {2} {1}'
else
  PREVIEW_CMD='cat {1} | tail -n +{2} | head -n 30'
fi

# Run skim with ripgrep and preview
selection=$(rg --line-number --no-heading --color=always . |
  sk --ansi \
    --delimiter : \
    --preview "$PREVIEW_CMD" \
    --preview-window=right:60%)

# If a result was selected, open it in editor at the correct line
if [ -n "$selection" ]; then
  file="$(echo "$selection" | cut -d: -f1)"
  line="$(echo "$selection" | cut -d: -f2)"
  "$EDITOR" "+${line}" "$file"
fi
