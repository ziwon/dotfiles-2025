set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default: install

install: install-tools install-git install-nvim install-tmux install-zsh install-configs install-claude

doctor:
  ./hack/utils/doctor.sh

bootstrap: install-just

install-just:
  if command -v mise >/dev/null 2>&1; then mise use -g just; elif command -v brew >/dev/null 2>&1; then brew install just; else echo "install just via mise or brew first"; fi

prep:
  if [[ "$(uname)" == "Darwin" ]]; then just prep-brew-perms; just install-coreutils; else echo "prep is only needed on macOS"; fi

prep-brew-perms:
  if [[ "$(uname)" == "Darwin" ]]; then sudo -S chown -R "${USER}" /Users/"${USER}"/Library/Caches/Homebrew /Users/"${USER}"/Library/Logs/Homebrew /opt/homebrew /opt/homebrew/Cellar /opt/homebrew/Frameworks /opt/homebrew/bin /opt/homebrew/etc /opt/homebrew/etc/bash_completion.d /opt/homebrew/include /opt/homebrew/lib /opt/homebrew/lib/pkgconfig /opt/homebrew/opt /opt/homebrew/sbin /opt/homebrew/share /opt/homebrew/share/aclocal /opt/homebrew/share/doc /opt/homebrew/share/info /opt/homebrew/share/man /opt/homebrew/share/man/man1 /opt/homebrew/share/man/man3 /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions /opt/homebrew/var/homebrew/linked /opt/homebrew/var/homebrew/locks; else echo "prep-brew-perms is macOS-only"; fi

install-coreutils:
  if command -v brew >/dev/null 2>&1; then brew install coreutils; else echo "brew not found"; fi

install-git:
  if [[ -n "${SUDO_USER:-}" ]]; then sudo -u "$SUDO_USER" ./hack/install/install-git.sh; else ./hack/install/install-git.sh; fi

install-nvim:
  if [[ -n "${SUDO_USER:-}" ]]; then sudo -u "$SUDO_USER" ./hack/install/install-nvim.sh; else ./hack/install/install-nvim.sh; fi

install-zsh:
  if [[ -n "${SUDO_USER:-}" ]]; then sudo -u "$SUDO_USER" ./hack/install/install-zsh.sh; else ./hack/install/install-zsh.sh; fi

install-tmux:
  if [[ -n "${SUDO_USER:-}" ]]; then sudo -u "$SUDO_USER" ./hack/install/install-tmux.sh; else ./hack/install/install-tmux.sh; fi

install-claude:
  if [[ -n "${SUDO_USER:-}" ]]; then sudo -u "$SUDO_USER" ./hack/install/install-claude.sh; else ./hack/install/install-claude.sh; fi

install-configs: install-bat install-btop install-eza install-ghostty install-mise

install-tools-configs: install-tools

install-tools:
  ./hack/install/full-install.sh --tools-only

install-bat:
  mkdir -p ~/.config/bat
  ln -sf {{justfile_directory()}}/config/bat/config ~/.config/bat/config

install-btop:
  mkdir -p ~/.config/btop
  ln -sf {{justfile_directory()}}/config/btop/btop.conf ~/.config/btop/btop.conf

install-eza:
  mkdir -p ~/.config/eza
  ln -sf {{justfile_directory()}}/config/eza/theme.yml ~/.config/eza/theme.yml

install-ghostty:
  mkdir -p ~/.config/ghostty
  ln -sf {{justfile_directory()}}/config/ghostty/config ~/.config/ghostty/config

install-mise:
  mkdir -p ~/.config/mise
  ln -sf {{justfile_directory()}}/config/mise/global-config.toml ~/.config/mise/config.toml

install-bash:
  ln -sf {{justfile_directory()}}/config/shell/bash/bashrc ~/.bashrc

install-tools-brew:
  if command -v brew >/dev/null 2>&1; then brew bundle --file {{justfile_directory()}}/Brewfile; else echo "brew not found; install Homebrew first"; fi
  if [[ "$(uname)" == "Darwin" && "$(uname -m)" == "arm64" ]]; then brew install mactop; fi

install-tools-ubuntu:
  ./hack/install/full-install.sh --tools-only

install-sysctl:
  if [[ "$(uname)" == "Linux" ]]; then sudo cp {{justfile_directory()}}/config/sysctl.d/99-network-performance.conf /etc/sysctl.d/99-network-performance.conf; sudo sysctl --system; else echo "install-sysctl is Linux-only"; fi
