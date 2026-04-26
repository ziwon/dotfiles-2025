#!/usr/bin/env bash
# Cross-platform installer for macOS and Ubuntu 24.04.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
die() { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

nvim_meets_minimum() {
  command -v nvim >/dev/null 2>&1 || return 1

  local parsed major minor
  parsed="$(nvim --version | sed -n '1s/.* v\{0,1\}\([0-9][0-9]*\)\.\([0-9][0-9]*\).*/\1 \2/p')"
  [[ -n "$parsed" ]] || return 1

  read -r major minor <<<"$parsed"
  (( major > 0 || minor >= 10 ))
}

install_ubuntu_neovim() {
  mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"
  export PATH="$HOME/.local/bin:$PATH"

  if nvim_meets_minimum; then
    info "Neovim already satisfies the required version: $(nvim --version | head -n1)"
    return 0
  fi

  local asset
  case "$(uname -m)" in
    x86_64|amd64)
      asset="nvim-linux-x86_64.tar.gz"
      ;;
    aarch64|arm64)
      asset="nvim-linux-arm64.tar.gz"
      ;;
    *)
      die "Unsupported architecture for Neovim release tarball: $(uname -m)"
      ;;
  esac

  local tmp_dir archive
  tmp_dir="$(mktemp -d)"
  archive="$tmp_dir/$asset"

  info "Installing Neovim 0.10+ from official release tarball..."
  curl -fL "https://github.com/neovim/neovim/releases/latest/download/$asset" -o "$archive"
  rm -rf "$HOME/.local/opt/nvim" "$HOME/.local/opt/nvim-linux-x86_64" "$HOME/.local/opt/nvim-linux-arm64"
  tar -xzf "$archive" -C "$HOME/.local/opt"

  local extracted
  extracted="$(find "$HOME/.local/opt" -maxdepth 1 -type d -name 'nvim-linux-*' | head -n1)"
  [[ -n "$extracted" ]] || die "Could not find extracted Neovim directory."

  mv "$extracted" "$HOME/.local/opt/nvim"
  ln -sf "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
  rm -rf "$tmp_dir"

  nvim_meets_minimum || die "Installed Neovim does not satisfy 0.10+."
  info "Installed $(nvim --version | head -n1)"
}

install_ubuntu_tools() {
  command -v apt-get >/dev/null 2>&1 || die "apt-get not found; Ubuntu 24.04 is expected."

  local required=(
    bat
    btop
    ca-certificates
    curl
    direnv
    fd-find
    fzf
    gh
    git
    git-delta
    gnupg
    jq
    ripgrep
    tmux
    unzip
    xclip
    zsh
  )

  info "Installing Ubuntu packages..."
  sudo apt-get update
  sudo apt-get install -y "${required[@]}"

  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi

  for optional in eza zoxide glab; do
    if ! command -v "$optional" >/dev/null 2>&1; then
      sudo apt-get install -y "$optional" || warn "Optional package not available via apt: $optional"
    fi
  done

  install_ubuntu_neovim
}

install_macos_tools() {
  command -v brew >/dev/null 2>&1 || die "Homebrew not found. Install Homebrew first: https://brew.sh"

  info "Installing Homebrew packages..."
  brew bundle --file "$DOTFILES_ROOT/Brewfile"
}

install_tools() {
  case "$(uname -s)" in
    Darwin)
      install_macos_tools
      ;;
    Linux)
      if [[ -r /etc/os-release ]] && grep -qi '^ID=ubuntu' /etc/os-release; then
        install_ubuntu_tools
      else
        warn "Linux detected, but this installer only manages Ubuntu packages."
      fi
      ;;
    *)
      die "Unsupported OS: $(uname -s)"
      ;;
  esac
}

main() {
  local tools_only=false

  case "${1:-}" in
    --tools-only)
      tools_only=true
      shift
      ;;
    -h|--help)
      cat <<EOF
Usage: $0 [--tools-only]

Install dotfiles for macOS or Ubuntu 24.04.

Options:
  --tools-only   Install OS packages only, then exit.
EOF
      exit 0
      ;;
    "")
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac

  info "Installing dotfiles from $DOTFILES_ROOT"
  install_tools

  if [[ "$tools_only" == true ]]; then
    exit 0
  fi

  "$DOTFILES_ROOT/hack/install/install-git.sh"
  "$DOTFILES_ROOT/hack/install/install-nvim.sh"
  "$DOTFILES_ROOT/hack/install/install-tmux.sh"
  "$DOTFILES_ROOT/hack/install/install-zsh.sh"
  "$DOTFILES_ROOT/hack/install/install-claude.sh"

  if command -v just >/dev/null 2>&1; then
    just --justfile "$DOTFILES_ROOT/Justfile" --working-directory "$DOTFILES_ROOT" install-configs
  else
    warn "just not found; skipped extra config symlinks. Install just and run: just install-configs"
  fi

  info "Installation complete. Restart your terminal or run: exec zsh"
}

main "$@"
