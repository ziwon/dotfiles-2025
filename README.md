# dotfiles-2025 🚀

> Modern development environment configuration for 2025 and beyond

A comprehensive, performance-optimized dotfiles setup featuring modern tools and cross-platform compatibility.

## ✨ Features

### **Core Applications**
- **🔧 Git**: Modern configuration with delta, GPG signing, GitHub/GitLab CLI integration
- **💻 Neovim**: LazyVim setup with LSP, debugging, completion, and GitHub Copilot
- **🐚 Zsh**: Zinit plugin manager, oh-my-posh prompt, 200+ productivity functions
- **🖥️ Tmux**: Modern configuration with TPM plugin management
- **⚙️ mise**: Tool version management (replaces asdf)

### **Development Tools**
- **Languages**: Python, JavaScript/TypeScript, Go, Rust, Kotlin, Terraform, Docker
- **Modern CLI**: eza, bat, rg, fd, zoxide, fzf integration
- **Productivity**: Extensive aliases, functions, and key bindings
- **WSL2**: Optimized for Windows Subsystem for Linux

## 🚀 Quick Start

### **Installation**
```bash
# Clone the repository
git clone https://github.com/ziwon/dotfiles-2025.git
cd dotfiles-2025

# Install everything on macOS or Ubuntu 24.04
./hack/install/full-install.sh

# If your base tools are already installed, you can use just directly
just install

# Or install individual components
./hack/install/install-git.sh      # Git configuration
./hack/install/install-tmux.sh     # tmux configuration
```

### **Manual Symlinking**
```bash
# Git configuration
ln -sf ~/dotfiles-2025/config/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles-2025/config/git/gitexclude ~/.gitexclude

# Zsh configuration
ln -sf ~/dotfiles-2025/config/shell/zsh/zshrc ~/.zshrc

# Neovim configuration
ln -sf ~/dotfiles-2025/config/nvim ~/.config/nvim

# tmux configuration
ln -sf ~/dotfiles-2025/config/tmux/tmux.conf ~/.tmux.conf
```

## 📁 Structure

```
dotfiles-2025/
├── config/                 # Application configurations
│   ├── git/                # Git config, aliases, global ignore
│   ├── nvim/               # Neovim LazyVim setup
│   ├── shell/              # Shell configurations
│   │   ├── bash/           # Basic bash setup
│   │   └── zsh/            # Comprehensive zsh setup
│   ├── tmux/               # Tmux configuration
│   └── mise/               # Tool version management
├── hack/                   # Installation and utility scripts
│   ├── install/            # Installation scripts
│   ├── setup/              # Setup utilities
│   └── utils/              # Maintenance utilities
└── docs/                   # Documentation
```

## ⚙️ Configuration Highlights

### **Git Features**
- Delta for beautiful diffs with Catppuccin theme
- Performance optimizations (fsmonitor, compression)
- Security settings (GPG signing, object verification)
- Modern workflows (autoStash, autoSquash)
- Comprehensive aliases and shortcuts

### **Neovim Features**
- LazyVim with GitHub Copilot integration
- Language servers for 10+ languages
- Debugging support with nvim-dap
- Modern UI with Catppuccin theme
- Performance-optimized configuration

### **Zsh Features**
- oh-my-posh prompt with custom themes
- 200+ productivity functions
- Modern tool replacements (eza, bat, rg, fd)
- Extensive git, docker, kubernetes aliases
- fzf integration with Catppuccin colors

## 🛠️ Requirements

- **Git** 2.20+
- **Neovim** 0.10+ recommended
- **Zsh** 5.0+
- **Node.js** (for LSP servers)
- **Python 3.8+** (for LSP servers)
- **oh-my-posh** (for prompt)

### **Optional Tools**
- **delta** (better git diffs)
- **eza** (modern ls replacement)
- **bat** (modern cat replacement)
- **ripgrep** (modern grep replacement)
- **fd** (modern find replacement)
- **zoxide** (smarter cd)
- **mise** (tool version management)

## Platform Notes

- macOS uses Homebrew and `Brewfile` for tool installation.
- Ubuntu 24.04 uses `apt-get` for the baseline toolchain and installs Neovim 0.10+ from the official Neovim release tarball.
- Wayland-specific setup is intentionally not part of the default install.

## 🧰 Maintenance

```bash
# Update git configuration
./hack/install/install-git.sh

# Verify installations
./hack/install/install-git.sh --verify

# Check nvim health
nvim --headless -c "checkhealth" -c "qa"

# Check the dotfiles environment
just doctor
```

## 🔧 Customization

### **Local Overrides**
- `~/.gitconfig.local` - Local git settings
- `~/.gitconfig.work` - Work-specific git settings  
- `~/.zshrc.local` - Local zsh customizations
- `~/.zshrc.work` - Work-specific zsh settings
- `~/.config/zsh/local.example.zsh` - Example snippets for machine-specific zsh settings

Git identity is intentionally not tracked in the shared `gitconfig`. Start from
`config/git/gitconfig.local.example` and save your machine-specific identity as
`~/.gitconfig.local`.

### **Theme Customization**
- oh-my-posh themes: `~/Workspace/oh-my-posh/themes/`
- Neovim colorscheme: LazyVim extras
- Terminal colors: Catppuccin Mocha

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Git Configuration Details](config/git/)
- [Neovim Setup Guide](config/nvim/)
- [Zsh Customization](config/shell/zsh/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration
- [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) - Cross-platform prompt
- [Catppuccin](https://github.com/catppuccin) - Soothing color scheme
- [mise](https://github.com/jdx/mise) - Tool version management

---

**Built with ❤️ for developer productivity in 2025**
