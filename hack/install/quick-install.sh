#!/bin/bash
# Quick installation script for dotfiles-2025

set -e

echo "🚀 Installing dotfiles-2025..."

# Clone repository
cd /tmp
git clone https://github.com/your-username/dotfiles-2025.git
cd dotfiles-2025

# Run full installation
chmod +x scripts/install/full-install.sh
./scripts/install/full-install.sh

echo "✨ Installation complete!"
echo "Restart your terminal or run: source ~/.bashrc"
