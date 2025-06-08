# fzf configuration for enhanced productivity

# Use fd for listing files
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Enhanced preview with bat and tree
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo {} | pbcopy)'
  --header 'CTRL-Y: copy path, CTRL-/: toggle preview'"

export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
  --bind 'ctrl-/:toggle-preview'"

# Advanced fzf functions
__fzf_git_log() {
  git log --oneline --color=always | 
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --preview 'git show --color=always {1}' \
      --bind 'ctrl-s:toggle-sort,ctrl-/:toggle-preview' \
      --header 'CTRL-S: toggle sort, CTRL-/: toggle preview'
}

__fzf_docker_containers() {
  docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | 
  tail -n +2 | 
  fzf --header-lines=0 \
      --preview 'docker inspect {1}' \
      --bind 'ctrl-/:toggle-preview'
}

__fzf_kubectl_pods() {
  kubectl get pods --all-namespaces | 
  tail -n +2 | 
  fzf --header-lines=0 \
      --preview 'kubectl describe pod {2} -n {1}' \
      --bind 'ctrl-/:toggle-preview'
}
