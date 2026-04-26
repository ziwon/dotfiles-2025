#!/bin/bash
# Install and configure modern Zsh setup

set -euo pipefail

CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing modern Zsh setup..."

# Install Zsh as default shell
if command -v zsh >/dev/null 2>&1; then
  ZSH_PATH="$(command -v zsh)"
  if [[ "${SHELL:-}" != "$ZSH_PATH" ]]; then
    if grep -qx "$ZSH_PATH" /etc/shells 2>/dev/null; then
      chsh -s "$ZSH_PATH" || echo "⚠️  Could not change default shell automatically."
    else
      echo "⚠️  $ZSH_PATH is not listed in /etc/shells; skipping chsh."
    fi
  fi
else
  echo "⚠️  zsh is not installed; install zsh first."
fi

# Install Zinit (idempotent)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname "$ZINIT_HOME")"
if [ -d "$ZINIT_HOME/.git" ]; then
  git -C "$ZINIT_HOME" pull --ff-only || true
else
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || true
fi

# Download Oh My Posh themes
if [ ! -d "$HOME/.poshthemes" ]; then
  echo "Downloading poshthemes..."
  mkdir -p "$HOME/.poshthemes"
  if command -v curl >/dev/null 2>&1 && command -v unzip >/dev/null 2>&1; then
    curl -sL https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -o "$HOME/themes.zip"
    unzip -qo "$HOME/themes.zip" -d "$HOME/.poshthemes"
    rm "$HOME/themes.zip"
  else
    echo "⚠️  curl or unzip missing; skipped downloading Oh My Posh themes."
  fi
fi

# Link Zsh configuration files
ln -sf "$CUR_DIR/../../config/shell/zsh/zshenv" "$HOME/.zshenv"
ln -sf "$CUR_DIR/../../config/shell/zsh/zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.config/zsh"
ln -sf "$CUR_DIR/../../config/shell/zsh/functions.zsh" "$HOME/.config/zsh/functions.zsh"
ln -sf "$CUR_DIR/../../config/shell/zsh/tmux.zsh" "$HOME/.config/zsh/tmux.zsh"
ln -sf "$CUR_DIR/../../config/shell/zsh/themes.zsh" "$HOME/.config/zsh/themes.zsh"
ln -sfn "$CUR_DIR/../../config/shell/zsh/fzf" "$HOME/.config/zsh/fzf"
ln -sfn "$CUR_DIR/../../config/shell/zsh/completions" "$HOME/.config/zsh/completions"

# Link to Oh My Posh theme
mkdir -p "$HOME/.poshthemes"
ln -sf "$CUR_DIR/../../config/shell/zsh/poshthemes/quick-term-python.omp.json" "$HOME/.poshthemes/quick-term-python.omp.json"

echo "✅ Zsh setup complete! Please restart your terminal or run 'zsh'"
