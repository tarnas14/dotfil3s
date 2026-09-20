#!/usr/bin/env bash
# install-apps.sh — every package the Arch + Sway setup uses, repositories and AUR.
# Safe to re-run: --needed skips what is already installed.
set -euo pipefail

if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found, bootstrapping it from the AUR"
  sudo pacman -S --needed --noconfirm base-devel git
  tmp="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi

repo=(
  # compositor and session
  sway swaybg swayidle waybar brightnessctl grim slurp pavucontrol xorg-xwayland
  greetd greetd-tuigreet
  linux-lts

  # audio, network, bluetooth, power
  pipewire pipewire-pulse pipewire-alsa wireplumber
  networkmanager network-manager-applet
  bluez bluez-utils blueman
  tlp tlp-rdw

  # launcher, notifications, portals, clipboard, screenshots, session helpers
  rofi rofi-emoji wtype
  mako libnotify
  xdg-desktop-portal-wlr xdg-desktop-portal-gtk
  polkit-gnome kanshi wlsunset
  wl-clipboard cliphist
  swappy wf-recorder gifski playerctl
  jq

  # Qt and GTK on Wayland, fonts, theming
  qt5-wayland qt6-wayland
  ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji noto-fonts-cjk
  papirus-icon-theme nwg-look

  # shell and terminal
  kitty zsh zsh-autosuggestions zsh-syntax-highlighting

  # development
  git base-devel neovim tree-sitter-cli mise
  docker docker-compose

  # system housekeeping
  man-db man-pages xdg-user-dirs
  ufw fwupd fprintd
  snapper snap-pac restic
  reflector pacman-contrib efibootmgr
  gnome-keyring libsecret

  # applications
  keepassxc syncthing signal-desktop
  thunar gvfs thunar-volman
  imv zathura zathura-pdf-mupdf mpv
  yazi-git ffmpeg 7zip poppler fd ripgrep fzf zoxide imagemagick resvg
  airpods-tui-git
)

aur=(
  brave-bin
  wl-clip-persist
  lazydocker
  keepmenu
  swaylock-fprintd-git # provides swaylock, pacman will offer to replace the upstream one
)

yay -S --needed "${repo[@]}" "${aur[@]}"

xdg-mime default imv.desktop image/png image/jpeg image/webp image/gif
xdg-mime default org.pwmt.zathura.desktop application/pdf
xdg-mime default mpv.desktop video/mp4 video/x-matroska

cat <<'EOF'

Packages installed. Services and one-time steps are still manual, see the guide:
  sudo systemctl enable greetd bluetooth ufw docker.socket reflector.timer paccache.timer
  sudo systemctl mask --now systemd-rfkill.service systemd-rfkill.socket && sudo systemctl enable --now tlp
  sudo systemctl enable NetworkManager-dispatcher
  sudo usermod -aG docker "$USER"
  systemctl --user enable --now syncthing
  chsh -s /usr/bin/zsh, then the Oh My Zsh installer, then log out and in
EOF
