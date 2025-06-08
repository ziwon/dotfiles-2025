#!/bin/bash
# Install and configure modern Zsh setup

echo "🚀 Installing modern Zsh setup..."

# Install Zsh as default shell
sudo apt install -y zsh
chsh -s $(which zsh)

# Install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Copy configurations
cp config/shell/zsh/zshrc ~/.zshrc
cp config/shell/zsh/p10k.zsh ~/.p10k.zsh

echo "✅ Zsh setup complete! Please restart your terminal or run 'zsh'"
