#!/bin/bash
# Install and configure modern Zsh setup

CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

echo "🚀 Installing modern Zsh setup..."

# Install Zsh as default shell
# sudo apt install -y zsh
chsh -s $(which zsh)

# Install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || true

# Download Oh My Posh themes
if [ ! -d "$HOME/.poshthemes" ]; then
  echo "Downloading poshthemes..."
  mkdir -p "$HOME/.poshthemes"
  curl -sL https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -o "$HOME/themes.zip"
  unzip -qo "$HOME/themes.zip" -d "$HOME/.poshthemes"
  rm "$HOME/themes.zip"
fi

# Link Zsh configuration files
ln -sf $CUR_DIR/../../config/shell/zsh/zshenv ~/.zshenv
ln -sf $CUR_DIR/../../config/shell/zsh/zshrc ~/.zshrc

# Link to Oh My Posh theme
ln -sf $CUR_DIR/../../config/shell/zsh/poshthemes/quick-term-python.omp.json ~/.poshthemes/quick-term-python.omp.json

echo "✅ Zsh setup complete! Please restart your terminal or run 'zsh'"
