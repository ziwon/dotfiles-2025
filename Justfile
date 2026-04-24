set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default: install

install: install-git install-nvim install-tmux install-zsh install-configs install-claude

bootstrap: install-just

install-just:
  if command -v mise >/dev/null 2>&1; then mise use -g just; elif command -v brew >/dev/null 2>&1; then brew install just; else echo "install just via mise or brew first"; fi

prep: prep-brew-perms install-coreutils

prep-brew-perms:
  sudo -S chown -R "${USER}" /Users/"${USER}"/Library/Caches/Homebrew /Users/"${USER}"/Library/Logs/Homebrew /opt/homebrew /opt/homebrew/Cellar /opt/homebrew/Frameworks /opt/homebrew/bin /opt/homebrew/etc /opt/homebrew/etc/bash_completion.d /opt/homebrew/include /opt/homebrew/lib /opt/homebrew/lib/pkgconfig /opt/homebrew/opt /opt/homebrew/sbin /opt/homebrew/share /opt/homebrew/share/aclocal /opt/homebrew/share/doc /opt/homebrew/share/info /opt/homebrew/share/man /opt/homebrew/share/man/man1 /opt/homebrew/share/man/man3 /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions /opt/homebrew/var/homebrew/linked /opt/homebrew/var/homebrew/locks

install-coreutils:
  brew install coreutils

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

install-tools-configs: install-tools-brew

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

install-tools-brew:
  if command -v brew >/dev/null 2>&1; then brew bundle --file {{justfile_directory()}}/Brewfile; else echo "brew not found; install Homebrew first"; fi
  if [[ "$(uname)" == "Darwin" && "$(uname -m)" == "arm64" ]]; then brew install mactop; fi

install-sysctl:
  if [[ "$(uname)" == "Linux" ]]; then sudo cp {{justfile_directory()}}/config/sysctl.d/99-network-performance.conf /etc/sysctl.d/99-network-performance.conf; sudo sysctl --system; else echo "install-sysctl is Linux-only"; fi

install-systemd:
  if [[ "$(uname)" == "Linux" ]]; then mkdir -p ~/.config/systemd/user; ln -sf {{justfile_directory()}}/config/systemd/symlink-wayland-socket.service ~/.config/systemd/user/symlink-wayland-socket.service; systemctl --user daemon-reload; systemctl --user enable --now symlink-wayland-socket.service; else echo "install-systemd is Linux-only"; fi
