#!/bin/bash
# Tmux configuration installer for dotfiles-2025
# Manages symlinks for tmux configuration files and TPM

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TMUX_CONFIG_DIR="$DOTFILES_ROOT/config/tmux"

# Function to print colored output
print_status() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Function to backup existing file
backup_file() {
  local file_path="$1"
  if [[ -f "$file_path" && ! -L "$file_path" ]]; then
    local backup_path="${file_path}.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing file: $file_path -> $backup_path"
    mv "$file_path" "$backup_path"
  fi
}

# Function to create symlink
create_symlink() {
  local source="$1"
  local target="$2"
  local description="$3"

  print_status "Installing $description..."

  if [[ ! -f "$source" ]]; then
    print_error "Source file not found: $source"
    return 1
  fi

  local target_dir
  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"

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

# Install tmux
install_tmux() {
  print_status "Checking tmux installation..."

  if command -v tmux &> /dev/null; then
    local tmux_version
    tmux_version="$(tmux -V)"
    print_success "tmux already installed: $tmux_version"
    return 0
  fi

  print_status "Installing tmux..."
  if command -v mise &> /dev/null; then
    mise use -g tmux
  elif command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y tmux
  elif command -v yum &> /dev/null; then
    sudo yum install -y tmux
  elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm tmux
  elif command -v brew &> /dev/null; then
    brew install tmux
  else
    print_error "No supported package manager found. Please install tmux manually."
    return 1
  fi

  print_success "tmux installed successfully"
}

# Install tmux configuration
install_tmux_config() {
  print_status "Installing tmux configuration..."

  create_symlink \
    "$TMUX_CONFIG_DIR/tmux.conf" \
    "$HOME/.tmux.conf" \
    "tmux configuration"
}

# Install TPM
install_tpm() {
  print_status "Installing TPM (tmux plugin manager)..."
  local tpm_dir="$HOME/.tmux/plugins/tpm"

  if [[ -d "$tpm_dir/.git" ]]; then
    git -C "$tpm_dir" pull --ff-only || true
  else
    mkdir -p "$(dirname "$tpm_dir")"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi

  print_success "TPM installed: $tpm_dir"
}

# Verify dependencies
verify_dependencies() {
  print_status "Verifying dependencies..."

  if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Git is required for TPM."
    return 1
  fi

  print_success "Git found"
}

# Test tmux configuration
test_tmux_config() {
  print_status "Testing tmux configuration..."

  if [[ -L "$HOME/.tmux.conf" ]]; then
    local target
    target="$(readlink "$HOME/.tmux.conf")"
    print_success "tmux config linked: $HOME/.tmux.conf -> $target"
  else
    print_error "tmux config not properly linked"
    return 1
  fi

  if command -v tmux &> /dev/null; then
    print_success "tmux available"
  else
    print_warning "tmux not found in PATH"
  fi
}

# Show usage
show_usage() {
  cat << EOF
Usage: $0 [OPTIONS]

Install tmux and configuration files from dotfiles-2025

OPTIONS:
    -h, --help          Show this help message
    -c, --config-only   Only install configuration, skip tmux installation
    -v, --verify        Only verify dependencies, don't install
    -t, --test          Test current configuration
    --backup-only       Only backup existing files, don't install

EXAMPLES:
    $0                      # Install tmux and configuration
    $0 --config-only       # Only install configuration
    $0 --verify            # Verify dependencies
    $0 --test              # Test current configuration

EOF
}

main() {
  local config_only=false
  local verify_only=false
  local test_only=false
  local backup_only=false

  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_usage
        exit 0
        ;;
      -c|--config-only)
        config_only=true
        shift
        ;;
      -v|--verify)
        verify_only=true
        shift
        ;;
      -t|--test)
        test_only=true
        shift
        ;;
      --backup-only)
        backup_only=true
        shift
        ;;
      *)
        print_error "Unknown option: $1"
        show_usage
        exit 1
        ;;
    esac
  done

  print_status "tmux Configuration Installer for dotfiles-2025"
  print_status "============================================="

  verify_dependencies

  if [[ "$verify_only" == true ]]; then
    print_success "Verification completed"
    exit 0
  fi

  if [[ "$test_only" == true ]]; then
    test_tmux_config
    exit 0
  fi

  if [[ "$backup_only" == true ]]; then
    print_status "Backing up existing tmux configuration..."
    backup_file "$HOME/.tmux.conf"
    print_success "Backup completed"
    exit 0
  fi

  if [[ "$config_only" != true ]]; then
    install_tmux
  fi

  install_tmux_config
  install_tpm
  test_tmux_config

  print_success "tmux configuration installation completed!"
  print_status "To install plugins, launch tmux and run: prefix + I"
}

main "$@"
