function fzg
    if set -q argv[1]
        set INITIAL_QUERY "$argv"
    else
        set INITIAL_QUERY ""
    end

    fzf --ansi --disabled --query $INITIAL_QUERY \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'right,50%,border-bottom,+{2}+3/3,~3' \
    --bind "enter:become(hx {1} +{2})"
end
