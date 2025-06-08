#!/bin/bash
# Git configuration installer for dotfiles-2025
# Manages symlinks for git configuration files

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
GIT_CONFIG_DIR="$DOTFILES_ROOT/config/git"

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
    
    # Check if source exists
    if [[ ! -f "$source" ]]; then
        print_error "Source file not found: $source"
        return 1
    fi
    
    # Create target directory if it doesn't exist
    local target_dir
    target_dir="$(dirname "$target")"
    mkdir -p "$target_dir"
    
    # Backup existing file if it's not a symlink
    backup_file "$target"
    
    # Remove existing symlink if it exists
    if [[ -L "$target" ]]; then
        print_warning "Removing existing symlink: $target"
        rm "$target"
    fi
    
    # Create symlink
    ln -sf "$source" "$target"
    print_success "$description installed: $target -> $source"
}

# Function to install git configurations
install_git_config() {
    print_status "Installing Git configuration files..."
    
    # Main git config
    create_symlink \
        "$GIT_CONFIG_DIR/gitconfig" \
        "$HOME/.gitconfig" \
        "Git configuration"
    
    # Git aliases (optional, can be included in main config)
    if [[ -f "$GIT_CONFIG_DIR/gitalias" ]]; then
        create_symlink \
            "$GIT_CONFIG_DIR/gitalias" \
            "$HOME/.gitalias" \
            "Git aliases"
    fi
    
    # Git exclude (global gitignore)
    create_symlink \
        "$GIT_CONFIG_DIR/gitexclude" \
        "$HOME/.gitexclude" \
        "Git global ignore"
}

# Function to verify git installation
verify_git_installation() {
    print_status "Verifying Git installation..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        return 1
    fi
    
    # Check if delta is installed (used in git config)
    if ! command -v delta &> /dev/null; then
        print_warning "Delta is not installed. Consider installing it for better diffs:"
        print_warning "  cargo install git-delta"
        print_warning "  or: apt install git-delta"
    fi
    
    # Check if gh is installed (used for GitHub authentication)
    if ! command -v gh &> /dev/null; then
        print_warning "GitHub CLI (gh) is not installed. Consider installing it:"
        print_warning "  https://cli.github.com/"
    fi
    
    print_success "Git installation verified"
}

# Function to test git configuration
test_git_config() {
    print_status "Testing Git configuration..."
    
    # Test basic git config
    local git_user
    git_user="$(git config --global user.name 2>/dev/null || echo "")"
    if [[ -n "$git_user" ]]; then
        print_success "Git user configured: $git_user"
    else
        print_warning "Git user not configured"
    fi
    
    local git_email
    git_email="$(git config --global user.email 2>/dev/null || echo "")"
    if [[ -n "$git_email" ]]; then
        print_success "Git email configured: $git_email"
    else
        print_warning "Git email not configured"
    fi
    
    # Test aliases
    if git config --global alias.s &> /dev/null; then
        print_success "Git aliases loaded successfully"
    else
        print_warning "Git aliases not found"
    fi
    
    print_success "Git configuration test completed"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install Git configuration files from dotfiles-2025

OPTIONS:
    -h, --help      Show this help message
    -v, --verify    Only verify installation, don't install
    -t, --test      Test current configuration
    --backup-only   Only backup existing files, don't install

EXAMPLES:
    $0                    # Install git configuration
    $0 --verify          # Verify git installation
    $0 --test            # Test current configuration
    $0 --backup-only     # Backup existing configs

EOF
}

# Main function
main() {
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
    
    print_status "Git Configuration Installer for dotfiles-2025"
    print_status "============================================="
    
    # Verify git installation
    verify_git_installation
    
    if [[ "$verify_only" == true ]]; then
        print_success "Verification completed"
        exit 0
    fi
    
    if [[ "$test_only" == true ]]; then
        test_git_config
        exit 0
    fi
    
    if [[ "$backup_only" == true ]]; then
        print_status "Backing up existing Git configuration files..."
        backup_file "$HOME/.gitconfig"
        backup_file "$HOME/.gitalias"
        backup_file "$HOME/.gitexclude"
        print_success "Backup completed"
        exit 0
    fi
    
    # Install git configuration
    install_git_config
    
    # Test the installation
    test_git_config
    
    print_success "Git configuration installation completed!"
    print_status "You may want to customize the following:"
    print_status "  - User name and email in ~/.gitconfig"
    print_status "  - GPG signing key"
    print_status "  - Work-specific configurations"
}

# Run main function with all arguments
main "$@"