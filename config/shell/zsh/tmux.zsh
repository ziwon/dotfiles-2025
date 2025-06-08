# Tmux integration and session management

# Smart tmux session management
tm() {
    local session_name="$1"
    
    if [ -z "$session_name" ]; then
        # List sessions and select with fzf
        session_name=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf)
        [ -z "$session_name" ] && return 1
    fi
    
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -d -s "$session_name"
        tmux attach-session -t "$session_name"
    fi
}

# Create project-based tmux session
tmux-project() {
    local project_path="$1"
    local session_name=$(basename "$project_path")
    
    if [ -z "$project_path" ]; then
        project_path=$(find ~/Projects ~/Workspace -maxdepth 1 -type d | fzf)
        [ -z "$project_path" ] && return 1
        session_name=$(basename "$project_path")
    fi
    
    tmux new-session -d -s "$session_name" -c "$project_path"
    tmux send-keys -t "$session_name" "nvim" Enter
    tmux new-window -t "$session_name" -c "$project_path"
    tmux attach-session -t "$session_name"
}

# Quick tmux window management
tw() {
    case "$1" in
        "new"|"n")
            tmux new-window
            ;;
        "list"|"l")
            tmux list-windows
            ;;
        "kill"|"k")
            local window=$(tmux list-windows -F "#{window_index}: #{window_name}" | fzf)
            [ -n "$window" ] && tmux kill-window -t "${window%%:*}"
            ;;
        *)
            echo "Usage: tw {new|list|kill}"
            ;;
    esac
}

# Auto-start tmux if not already in session
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    # Only auto-start in interactive shells
    if [[ $- == *i* ]]; then
        exec tmux new-session -A -s main
    fi
fi
