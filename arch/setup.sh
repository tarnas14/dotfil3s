#!/usr/bin/env bash
# arch/setup.sh — link dotfiles from this repository into place on the Arch + sway machine.
# Shared files sit at the repository root, Arch-only ones under arch/.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# pairs: path relative to the repository root, destination directory
setup=(
  # shared
  ".gitconfig" "$HOME"
  ".gitignore_global" "$HOME"
  "kitty/kitty.conf" "$HOME/.config/kitty"
  "kitty/reading_mode.py" "$HOME/.config/kitty"
  "nvim" "$HOME/.config"
  "zsh/.zshrc" "$HOME"
  "zsh/.zshenv" "$HOME"
  "arch/.zshrc-local" "$HOME"
  "arch/kitty/current-theme.conf" "$HOME/.config/kitty"
  "arch/kitty/local-theme-overrides.conf" "$HOME/.config/kitty"
  "arch/rofi/config.rasi" "$HOME/.config/rofi"
  "arch/kanshi/config" "$HOME/.config/kanshi"
  "arch/local-bin/lid-check" "$HOME/.local/bin"
  "arch/local-bin/screenrec" "$HOME/.local/bin"
  "arch/local-bin/rofi-clip" "$HOME/.local/bin"
  "arch/local-bin/rofi-kanshi" "$HOME/.local/bin"
  "arch/local-bin/waybar-rec" "$HOME/.local/bin"
  "arch/mako/config" "$HOME/.config/mako"
  "arch/sway/config" "$HOME/.config/sway"
  "arch/swaylock/config" "$HOME/.config/swaylock"
  "arch/waybar/config.jsonc" "$HOME/.config/waybar"
  "arch/waybar/style.css" "$HOME/.config/waybar"
  "arch/xdg-desktop-portal/sway-portals.conf" "$HOME/.config/xdg-desktop-portal"
)

warn() { printf 'warn  %s\n' "$*" >&2; }
ok() { printf 'ok    %s\n' "$*"; }

link() {
  local src="$1" dest="$2"
  if [[ ! -e "$src" ]]; then
    warn "${src#"$root"/}: not in the repository, skipped"
  elif [[ -L "$dest" ]]; then
    if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
      ok "$dest already linked"
    else
      warn "$dest is a link to $(readlink "$dest"), left alone"
    fi
  elif [[ -e "$dest" ]]; then
    warn "$dest exists and is not a symlink, left alone"
  else
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    ok "$dest -> ${src#"$root"/}"
  fi
}

for ((i = 0; i < ${#setup[@]}; i += 2)); do
  link "$root/${setup[i]}" "${setup[i + 1]}/$(basename "${setup[i]}")"
done

# links whose name differs from the file in the repository
link "$root/arch/gitconfig.local" "$HOME/.gitconfig.local"
link "$root/rofi/config.rasi" "$HOME/.config/rofi/base.rasi"
