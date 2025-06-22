#!/bin/bash
# Neovim configuration installer for dotfiles-2025
# Manages symlinks for Neovim configuration files

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
NVIM_CONFIG_DIR="$DOTFILES_ROOT/config/nvim"

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

# Function to backup existing directory/file
backup_path() {
    local path="$1"
    if [[ -e "$path" && ! -L "$path" ]]; then
        local backup_path="${path}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing path: $path -> $backup_path"
        mv "$path" "$backup_path"
    fi
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    print_status "Installing $description..."
    
    # Check if source exists
    if [[ ! -d "$source" ]]; then
        print_error "Source directory not found: $source"
        return 1
    fi
    
    # Create target parent directory if it doesn't exist
    local target_parent
    target_parent="$(dirname "$target")"
    mkdir -p "$target_parent"
    
    # Backup existing directory if it's not a symlink
    backup_path "$target"
    
    # Remove existing symlink if it exists
    if [[ -L "$target" ]]; then
        print_warning "Removing existing symlink: $target"
        rm "$target"
    fi
    
    # Create symlink
    ln -sf "$source" "$target"
    print_success "$description installed: $target -> $source"
}

# Function to install Neovim
install_neovim() {
    print_status "Checking Neovim installation..."
    
    if command -v nvim &> /dev/null; then
        local nvim_version
        nvim_version="$(nvim --version | head -n1)"
        print_success "Neovim already installed: $nvim_version"
    else
        print_status "Installing Neovim..."
        
        # Try different package managers
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y neovim
        elif command -v yum &> /dev/null; then
            sudo yum install -y neovim
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm neovim
        elif command -v brew &> /dev/null; then
            brew install neovim
        else
            print_error "No supported package manager found. Please install Neovim manually."
            return 1
        fi
        
        print_success "Neovim installed successfully"
    fi
}

# Function to install Neovim configuration
install_nvim_config() {
    print_status "Installing Neovim configuration..."
    
    create_symlink \
        "$NVIM_CONFIG_DIR" \
        "$HOME/.config/nvim" \
        "Neovim configuration"
}

# Function to verify dependencies
verify_dependencies() {
    print_status "Verifying dependencies..."
    
    # Check for Node.js (required by many plugins)
    if ! command -v node &> /dev/null; then
        print_warning "Node.js is not installed. Many plugins may not work properly."
        print_warning "Consider installing Node.js: https://nodejs.org/"
    else
        local node_version
        node_version="$(node --version)"
        print_success "Node.js found: $node_version"
    fi
    
    # Check for Python (required by some plugins)
    if ! command -v python3 &> /dev/null; then
        print_warning "Python3 is not installed. Some plugins may not work."
    else
        local python_version
        python_version="$(python3 --version)"
        print_success "Python3 found: $python_version"
    fi
    
    # Check for git (required for plugin management)
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Git is required for plugin management."
        return 1
    else
        print_success "Git found"
    fi
    
    # Check for ripgrep (useful for telescope)
    if ! command -v rg &> /dev/null; then
        print_warning "ripgrep is not installed. Consider installing for better search:"
        print_warning "  cargo install ripgrep"
        print_warning "  or: apt install ripgrep"
    else
        print_success "ripgrep found"
    fi
    
    # Check for fd (useful for telescope)
    if ! command -v fd &> /dev/null; then
        print_warning "fd is not installed. Consider installing for better file finding:"
        print_warning "  cargo install fd-find"
        print_warning "  or: apt install fd-find"
    else
        print_success "fd found"
    fi
}

# Function to test Neovim configuration
test_nvim_config() {
    print_status "Testing Neovim configuration..."
    
    # Check if config directory is properly linked
    if [[ -L "$HOME/.config/nvim" ]]; then
        local target
        target="$(readlink "$HOME/.config/nvim")"
        print_success "Neovim config linked: $HOME/.config/nvim -> $target"
    else
        print_error "Neovim config not properly linked"
        return 1
    fi
    
    # Check if init.lua exists
    if [[ -f "$HOME/.config/nvim/init.lua" ]]; then
        print_success "init.lua found"
    else
        print_warning "init.lua not found"
    fi
    
    # Test nvim startup (headless mode)
    print_status "Testing Neovim startup..."
    if nvim --headless -c 'qall' 2>/dev/null; then
        print_success "Neovim starts successfully"
    else
        print_warning "Neovim startup test failed (this might be normal for first run)"
    fi
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install Neovim and configuration files from dotfiles-2025

OPTIONS:
    -h, --help          Show this help message
    -c, --config-only   Only install configuration, skip Neovim installation
    -v, --verify        Only verify dependencies, don't install
    -t, --test          Test current configuration
    --backup-only       Only backup existing files, don't install

EXAMPLES:
    $0                      # Install Neovim and configuration
    $0 --config-only       # Only install configuration
    $0 --verify            # Verify dependencies
    $0 --test              # Test current configuration

EOF
}

# Main function
main() {
    local config_only=false
    local verify_only=false
    local test_only=false
    local backup_only=false
    
    # Parse command line arguments
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
    
    print_status "Neovim Configuration Installer for dotfiles-2025"
    print_status "==============================================="
    
    # Verify dependencies
    verify_dependencies
    
    if [[ "$verify_only" == true ]]; then
        print_success "Verification completed"
        exit 0
    fi
    
    if [[ "$test_only" == true ]]; then
        test_nvim_config
        exit 0
    fi
    
    if [[ "$backup_only" == true ]]; then
        print_status "Backing up existing Neovim configuration..."
        backup_path "$HOME/.config/nvim"
        print_success "Backup completed"
        exit 0
    fi
    
    # Install Neovim if not config-only
    if [[ "$config_only" != true ]]; then
        install_neovim
    fi
    
    # Install configuration
    install_nvim_config
    
    # Test the installation
    test_nvim_config
    
    print_success "Neovim configuration installation completed!"
    print_status "First launch might take a while as plugins are installed."
    print_status "Launch Neovim with: nvim"
    
    if [[ "$config_only" != true ]]; then
        print_status ""
        print_status "Consider installing additional tools for better experience:"
        print_status "  - ripgrep: for better search functionality"
        print_status "  - fd: for better file finding"
        print_status "  - Node.js: for LSP and plugin support"
        print_status "  - A Nerd Font: for better icons"
    fi
}

# Run main function with all arguments
main "$@"