#!/bin/bash
# Full installation script for dotfiles-2025

set -e

echo "🚀 Starting dotfiles-2025 installation..."

# 1. Install mise
echo "📦 Installing mise..."
curl -L https://mise.run | sh

# Add to shell
MISE_PATH="$HOME/.local/bin/mise"
if [[ $SHELL == *"zsh"* ]]; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
elif [[ $SHELL == *"bash"* ]]; then
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
fi

# Source mise
eval "$($MISE_PATH activate bash)"

# 2. Install system dependencies
echo "🔧 Installing system dependencies..."
sudo apt update
sudo apt install -y \
    curl git build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev \
    liblzma-dev ripgrep fd-find unzip ca-certificates gnupg \
    lsb-release xclip wl-clipboard fzf tree-sitter-cli \
    imagemagick ghostscript poppler-utils

# 3. Install development tools via mise
echo "🐍 Installing development tools..."
$MISE_PATH use --global python@3.12
$MISE_PATH use --global node@22
$MISE_PATH use --global go@latest
$MISE_PATH use --global terraform@latest
$MISE_PATH use --global kubectl@latest
$MISE_PATH use --global helm@latest
$MISE_PATH use --global lazygit@latest

# 4. Install Neovim
echo "📝 Installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz

# 5. Install Python packages
echo "🐍 Installing Python packages..."
pip install --upgrade \
    pynvim python-lsp-server black isort flake8 mypy \
    debugpy jupyter ipython

# 6. Install npm packages
echo "📦 Installing npm packages..."
npm install -g \
    neovim prettier eslint typescript \
    typescript-language-server yaml-language-server

# 7. Install Ollama (optional)
echo "🤖 Installing Ollama..."
curl -fsSL https://ollama.ai/install.sh | sh
sudo systemctl enable ollama
sudo systemctl start ollama

# 8. Copy configurations
echo "📋 Installing configurations..."

# Backup existing configs
[ -f ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.backup
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup

# Copy new configurations
cp config/tmux/tmux.conf ~/.tmux.conf
cp -r config/nvim ~/.config/
cp config/mise/global-config.toml ~/.config/mise/config.toml

# 9. Install tmux plugins
echo "🎨 Installing tmux plugins..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 10. Setup Neovim
echo "📝 Setting up Neovim..."
nvim --headless "+Lazy! sync" +qa

echo "
🎉 dotfiles-2025 installation complete!

🚀 Next steps:
   1. Restart your terminal: source ~/.bashrc
   2. Install tmux plugins: tmux source ~/.tmux.conf, then Ctrl-a + I
   3. Test setup: nvim +checkhealth
   4. Download AI models: ollama pull codestral

📚 Documentation: https://github.com/your-username/dotfiles-2025

✨ Happy coding!
"
