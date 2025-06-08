# Alternative fzf setup for systems with widget loading issues

# Manual fzf widget creation if auto-loading fails
if command -v fzf &> /dev/null; then
    # Create widgets manually if they don't exist
    if [[ -z "${widgets[fzf-history-widget]}" ]]; then
        fzf-history-widget() {
            local selected num
            selected=$(fc -rl 1 | fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r) &&
            num=$(echo "$selected" | head -1 | awk '{print $1}' | sed 's/[^0-9]//g') &&
            zle vi-fetch-history -n $num
            zle reset-prompt
        }
        zle -N fzf-history-widget
    fi
    
    if [[ -z "${widgets[fzf-file-widget]}" ]]; then
        fzf-file-widget() {
            local selected
            selected=$(find . -type f 2>/dev/null | fzf) &&
            LBUFFER="${LBUFFER}${selected}"
            zle reset-prompt
        }
        zle -N fzf-file-widget
    fi
    
    if [[ -z "${widgets[fzf-cd-widget]}" ]]; then
        fzf-cd-widget() {
            local selected
            selected=$(find . -type d 2>/dev/null | fzf) &&
            cd "$selected"
            zle reset-prompt
        }
        zle -N fzf-cd-widget
    fi
fi
