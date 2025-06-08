# Installation Guide

## Prerequisites
- Ubuntu 24.04 or compatible Linux distribution
- Internet connection
- Git installed

## Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/ziwon/dotfiles-2025/main/scripts/install/quick-install.sh | bash
```

## Manual Installation
See [full-install.sh](../hack/install/full-install.sh) for complete setup.

## Post-Installation
1. Restart terminal
2. Run health checks: `nvim +checkhealth`
3. Install tmux plugins: `tmux source ~/.tmux.conf`
