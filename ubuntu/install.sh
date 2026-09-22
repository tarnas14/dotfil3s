#!/usr/bin/env bash
# ubuntu/install.sh — packages and one-off downloads for the Ubuntu + GNOME + Forge setup.
# Counterpart of arch-install.sh. Safe to re-run.
set -euo pipefail

# GitHub release downloads go through a redirect that returns 5xx now and then; retry instead of aborting
fetch() { curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors -o "$1" "$2"; }

sudo apt update
sudo apt install -y \
  `# shell, terminal, editor tooling` \
  zsh kitty git build-essential unzip curl jq \
  fzf ripgrep fd-find zoxide tree-sitter-cli shfmt lazygit btop \
  `# mason installs python servers (basedpyright) into a venv, ubuntu splits that out of python3` \
  python3-venv python3-pip \
  `# launcher, clipboard, notifications` \
  rofi rofimoji wl-clipboard libnotify-bin papirus-icon-theme \
  `# clipboard history: GPaste tracks it from inside the shell, cliphist cannot on Mutter` \
  gnome-shell-extension-gpaste \
  `# gnome extension plumbing: auto-move-windows lives in gnome-shell-extensions` \
  gnome-shell-extensions gnome-shell-extension-manager gettext \
  `# fonts` \
  fonts-noto-color-emoji fonts-noto-cjk \
  `# development` \
  docker.io docker-compose-v2 \
  `# applications` \
  syncthing playerctl \
  imv zathura mpv ffmpeg 7zip poppler-utils imagemagick resvg \
  `# system` \
  restic fprintd libpam-fprintd gnome-keyring

# Google Cloud CLI from Google's apt repository (docs.cloud.google.com/sdk/docs/install-sdk#deb),
# plus kubectl and the GKE auth plugin, which the base package does not include
if [[ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]]; then
  sudo apt-get install -y ca-certificates gnupg curl
  curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/cloud.google.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
  sudo apt-get update
fi
sudo apt-get install -y google-cloud-cli kubectl google-cloud-cli-gke-gcloud-auth-plugin

# Spotify: the snap is published by Spotify itself; Brave and Slack are snaps here too
snap list spotify >/dev/null 2>&1 || sudo snap install spotify

mkdir -p ~/.local/bin ~/.local/share/fonts

# Ubuntu ships fd as fdfind; fzf-lua and yazi look for fd
ln -sf "$(command -v fdfind)" ~/.local/bin/fd

# Neovim: apt has 0.11, the config is written for 0.12
if ! command -v nvim >/dev/null || [[ "$(nvim --version | head -1)" != *"v0.12"* ]]; then
  echo "installing Neovim 0.12 from GitHub releases into /opt"
  fetch /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf /tmp/nvim.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
fi

# yazi is not packaged for Ubuntu
if ! command -v yazi >/dev/null; then
  echo "installing yazi from GitHub releases"
  fetch /tmp/yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
  unzip -qo /tmp/yazi.zip -d /tmp/yazi
  install -m755 /tmp/yazi/yazi-x86_64-unknown-linux-gnu/{yazi,ya} ~/.local/bin/
  rm -rf /tmp/yazi /tmp/yazi.zip
fi

# airpods-tui: battery, noise modes and settings over Apple's AACP, same tool as on Arch.
# Prebuilt tarball from GitHub; the AUR hook's three steps done by hand: binary, user
# service, and an Apple DeviceID in bluez's main.conf (AirPods only open the AACP
# channel to a host that identifies as Apple). AirPods paired before the DeviceID was
# set have to be forgotten and paired again.
if ! command -v airpods-tui >/dev/null; then
  echo "installing airpods-tui from GitHub releases"
  url="$(curl -fsSL https://api.github.com/repos/annoyedmilk/airpods-tui/releases/latest \
        | jq -r '.assets[] | select(.name | test("x86_64\\.tar\\.gz$")) | .browser_download_url')"
  fetch /tmp/airpods-tui.tgz "$url"
  rm -rf /tmp/airpods-tui && mkdir -p /tmp/airpods-tui && tar -xzf /tmp/airpods-tui.tgz -C /tmp/airpods-tui --strip-components=1
  install -m755 /tmp/airpods-tui/airpods-tui ~/.local/bin/
  mkdir -p ~/.config/systemd/user
  sed "s|ExecStart=/usr/bin/airpods-tui|ExecStart=$HOME/.local/bin/airpods-tui|" /tmp/airpods-tui/airpods-tui.service \
    > ~/.config/systemd/user/airpods-tui.service
  rm -rf /tmp/airpods-tui /tmp/airpods-tui.tgz
fi
if ! grep -qE '^\s*DeviceID\s*=\s*bluetooth:004C:' /etc/bluetooth/main.conf; then
  echo "setting the Apple DeviceID in /etc/bluetooth/main.conf"
  if grep -q '^\[General\]' /etc/bluetooth/main.conf; then
    sudo sed -i '/^\[General\]/a DeviceID = bluetooth:004C:0000:0000' /etc/bluetooth/main.conf
  else
    printf '\n[General]\nDeviceID = bluetooth:004C:0000:0000\n' | sudo tee -a /etc/bluetooth/main.conf >/dev/null
  fi
  sudo systemctl restart bluetooth
  echo "  AirPods paired before this need to be forgotten and paired again"
fi
systemctl --user daemon-reload
systemctl --user enable --now airpods-tui.service

# JetBrainsMono Nerd Font (kitty uses JetBrainsMonoNL Nerd Font Mono, the apt font is unpatched)
if ! fc-list | grep -q "JetBrainsMonoNL Nerd Font Mono"; then
  echo "installing JetBrainsMono Nerd Font"
  fetch /tmp/jbm.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
  tar -C ~/.local/share/fonts/JetBrainsMonoNerd -xJf /tmp/jbm.tar.xz
  fc-cache -f
  rm /tmp/jbm.tar.xz
fi

# mise (node, python, whatever the projects need), the omz plugin activates it
command -v mise >/dev/null || curl -fsSL https://mise.run | sh

# Oh My Zsh, unattended so it does not replace .zshrc or switch shells itself
[[ -d ~/.oh-my-zsh ]] || RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# with no .zshrc to keep, the installer writes its template; drop it so setup.sh can link ours
if [[ -f ~/.zshrc && ! -L ~/.zshrc ]] && diff -q ~/.zshrc ~/.oh-my-zsh/templates/zshrc.zsh-template >/dev/null; then
  rm ~/.zshrc
fi

# GNOME extensions from extensions.gnome.org for the running shell version
shell_version="$(gnome-shell --version | grep -oE '[0-9]+' | head -1)"
install_ext() {
  local uuid="$1"
  [[ -d ~/.local/share/gnome-shell/extensions/$uuid ]] && {
    echo "$uuid already installed"
    return
  }
  local url
  url="$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=$uuid&shell_version=$shell_version" | jq -r .download_url)"
  [[ "$url" == /* ]] || {
    echo "no build of $uuid for GNOME $shell_version" >&2
    return 1
  }
  fetch "/tmp/$uuid.zip" "https://extensions.gnome.org$url"
  gnome-extensions install --force "/tmp/$uuid.zip"
  rm "/tmp/$uuid.zip"
  echo "installed $uuid"
}
# Forge: the extensions.gnome.org build (v89) stops at GNOME 49 and the shell then
# reports it OUT OF DATE. The main branch carries GNOME 50 metadata, so build from git
# when the installed copy does not list the running shell version.
forge_dir=~/.local/share/gnome-shell/extensions/forge@jmmaranan.com
if ! jq -e --arg v "$shell_version" '.["shell-version"] | index($v)' "$forge_dir/metadata.json" >/dev/null 2>&1; then
  echo "building Forge from git for GNOME $shell_version"
  src="$(mktemp -d)"
  git clone --quiet --depth 50 https://github.com/forge-ext/forge.git "$src/forge"
  rm -rf "$forge_dir"
  make -C "$src/forge" build install >/dev/null
  rm -rf "$src"
  echo "installed forge@jmmaranan.com $(jq -r .version "$forge_dir/metadata.json") from git"
fi
install_ext window-calls@domandoman.xyz # D-Bus window list for ~/.local/bin/rofi-window
install_ext notification-position@drugo.dev # banners top-right instead of top-centre, where mako had them
install_ext top-bar-organizer@julian.gse.jsts.xyz # clock next to the tray icons, waybar style

sudo usermod -aG docker "$USER"

# INSTALLING SIGNAL
## 1. Install our official public software signing key:
curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor >signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg >/dev/null

## 2. Add our repository to your list of repositories:
curl -o signal-desktop.sources https://updates.signal.org/static/desktop/apt/signal-desktop.sources
cat signal-desktop.sources | sudo tee /etc/apt/sources.list.d/signal-desktop.sources >/dev/null

## 3. Update your package database and install Signal:
sudo apt update && sudo apt install signal-desktop

cat <<'MSG'

Done. Still manual:
  chsh -s /usr/bin/zsh
  ./ubuntu/setup.sh            symlinks
  ./ubuntu/gnome-settings.sh   keybindings, workspaces, keyboard, extensions
  log out and back in          new extensions load, zsh becomes the shell, docker group applies
  mise use -g node@lts         then start nvim once; lazy and mason install everything
  GPG: import the signing key or set commit.gpgsign=false for this machine
MSG
