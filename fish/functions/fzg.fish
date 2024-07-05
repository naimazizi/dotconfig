function fzg
    fzf --ansi --disabled --query $argv[1] \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview "bat --color=always {1} --highlight-line {2}" \
    --preview-window "up,60%,border-bottom,+{2}+3/3,~3" \
    --bind "enter:become(hx {1} +{2})"
end
