# Installation Guide

## Prerequisites
- macOS with Homebrew, or Ubuntu 24.04
- Internet connection
- Git installed

## Quick Install
```bash
git clone https://github.com/ziwon/dotfiles-2025.git
cd dotfiles-2025
./hack/install/full-install.sh
```

## Manual Installation
```bash
just install
```

See [full-install.sh](../hack/install/full-install.sh) for complete setup.

## Post-Installation
1. Restart terminal
2. Run health checks: `nvim +checkhealth`
3. Install tmux plugins inside tmux: prefix + `I`

## Neovim
Ubuntu 24.04 may provide an older Neovim through `apt`. The installer uses the official Neovim release tarball and links it at `~/.local/bin/nvim` so LazyVim has Neovim 0.10+.

## Toolchain
On Ubuntu 24.04, the installer uses `apt-get` for distro packages and adds the official mise apt repository when `mise` is missing. Tools that are better managed outside apt can then be installed through mise.
