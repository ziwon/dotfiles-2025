#!/bin/bash
# Claude Code configuration installer for dotfiles-2025
# Manages symlinks for ~/.claude settings, hooks, and scripts

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLAUDE_CONFIG_DIR="$DOTFILES_ROOT/config/claude"

print_status()  { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

backup_file() {
  local file_path="$1"
  if [[ -f "$file_path" && ! -L "$file_path" ]]; then
    local backup_path="${file_path}.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing file: $file_path -> $backup_path"
    mv "$file_path" "$backup_path"
  fi
}

create_symlink() {
  local source="$1"
  local target="$2"
  local description="$3"

  print_status "Installing $description..."

  if [[ ! -f "$source" ]]; then
    print_error "Source file not found: $source"
    return 1
  fi

  mkdir -p "$(dirname "$target")"
  backup_file "$target"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      print_success "$description already linked: $target -> $source"
      return 0
    fi
    print_warning "Removing existing symlink: $target"
    rm "$target"
  fi

  ln -sf "$source" "$target"
  print_success "$description installed: $target -> $source"
}

install_claude_config() {
  print_status "Claude Code Configuration Installer for dotfiles-2025"
  print_status "====================================================="

  mkdir -p "$HOME/.claude/hooks"

  create_symlink "$CLAUDE_CONFIG_DIR/CLAUDE.md" \
    "$HOME/.claude/CLAUDE.md" \
    "CLAUDE.md"

  create_symlink "$CLAUDE_CONFIG_DIR/RTK.md" \
    "$HOME/.claude/RTK.md" \
    "RTK.md"

  create_symlink "$CLAUDE_CONFIG_DIR/settings.json" \
    "$HOME/.claude/settings.json" \
    "settings.json"

  create_symlink "$CLAUDE_CONFIG_DIR/hooks/rtk-rewrite.sh" \
    "$HOME/.claude/hooks/rtk-rewrite.sh" \
    "rtk-rewrite hook"

  create_symlink "$CLAUDE_CONFIG_DIR/statusline-command.sh" \
    "$HOME/.claude/statusline-command.sh" \
    "statusline-command script"

  create_symlink "$CLAUDE_CONFIG_DIR/rtk-statusline.sh" \
    "$HOME/.claude/rtk-statusline.sh" \
    "rtk-statusline widget"

  print_success "Claude Code configuration installation completed!"
}

install_claude_config
