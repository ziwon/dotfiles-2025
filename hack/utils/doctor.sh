#!/usr/bin/env bash
# Validate the dotfiles environment after install.

set -u

failures=0
warnings=0

ok() { printf '[OK] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; warnings=$((warnings + 1)); }
fail() { printf '[FAIL] %s\n' "$*"; failures=$((failures + 1)); }
info() { printf '[INFO] %s\n' "$*"; }

has_command() {
  command -v "$1" >/dev/null 2>&1
}

check_required_command() {
  local cmd="$1"
  if has_command "$cmd"; then
    ok "$cmd: $(command -v "$cmd")"
  else
    fail "missing required command: $cmd"
  fi
}

check_optional_command() {
  local cmd="$1"
  if has_command "$cmd"; then
    ok "$cmd: $(command -v "$cmd")"
  else
    warn "missing optional command: $cmd"
  fi
}

nvim_meets_minimum() {
  has_command nvim || return 1

  local parsed major minor
  parsed="$(nvim --version | sed -n '1s/.* v\{0,1\}\([0-9][0-9]*\)\.\([0-9][0-9]*\).*/\1 \2/p')"
  [[ -n "$parsed" ]] || return 1

  read -r major minor <<<"$parsed"
  (( major > 0 || minor >= 10 ))
}

check_link() {
  local target="$1"
  local expected_fragment="$2"

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    warn "$target is not installed"
    return
  fi

  if [[ ! -L "$target" ]]; then
    warn "$target exists but is not a symlink"
    return
  fi

  local dest
  dest="$(readlink "$target")"
  if [[ "$dest" == *"$expected_fragment"* ]]; then
    ok "$target -> $dest"
  else
    warn "$target points to unexpected target: $dest"
  fi
}

check_git_identity() {
  local name email
  name="$(git config --global user.name 2>/dev/null || true)"
  email="$(git config --global user.email 2>/dev/null || true)"

  if [[ -n "$name" ]]; then
    ok "git user.name: $name"
  else
    fail "git user.name is not configured"
  fi

  if [[ -n "$email" ]]; then
    ok "git user.email: $email"
  else
    fail "git user.email is not configured"
  fi

  if [[ -f "$HOME/.gitconfig.local" ]]; then
    ok "$HOME/.gitconfig.local exists"
  else
    warn "$HOME/.gitconfig.local is missing; copy from ~/.gitconfig.local.example"
  fi
}

main() {
  info "OS: $(uname -s) $(uname -m)"
  info "Shell: ${SHELL:-unknown}"
  info "PATH: $PATH"

  printf '\nRequired commands\n'
  for cmd in git zsh tmux nvim fzf rg jq; do
    check_required_command "$cmd"
  done

  if has_command fd || has_command fdfind; then
    ok "fd/fdfind: $(command -v fd 2>/dev/null || command -v fdfind)"
  else
    fail "missing required command: fd or fdfind"
  fi

  if has_command bat || has_command batcat; then
    ok "bat/batcat: $(command -v bat 2>/dev/null || command -v batcat)"
  else
    fail "missing required command: bat or batcat"
  fi

  printf '\nNeovim\n'
  if nvim_meets_minimum; then
    ok "$(nvim --version | head -n1)"
  else
    fail "Neovim 0.10+ is required"
  fi

  printf '\nOptional commands\n'
  for cmd in brew apt-get mise oh-my-posh zoxide direnv gh glab delta kubectl kubecolor eza vivid; do
    check_optional_command "$cmd"
  done

  printf '\nInstalled links\n'
  check_link "$HOME/.zshrc" "config/shell/zsh/zshrc"
  check_link "$HOME/.zshenv" "config/shell/zsh/zshenv"
  check_link "$HOME/.tmux.conf" "config/tmux/tmux.conf"
  check_link "$HOME/.gitconfig" "config/git/gitconfig"
  check_link "$HOME/.config/nvim" "config/nvim"

  printf '\nGit identity\n'
  check_git_identity

  printf '\nSummary\n'
  if (( failures > 0 )); then
    fail "$failures required check(s) failed; $warnings warning(s)"
    return 1
  fi

  ok "all required checks passed; $warnings warning(s)"
}

main "$@"
