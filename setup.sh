#!/usr/bin/env bash
# setup.sh — link dotfiles from this repository into place
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# pairs: path relative to this file, destination directory
setup=(
    ".gitconfig"                           "$HOME"
    ".gitignore_global"                    "$HOME"
    "kanshi/config"                        "$HOME/.config/kanshi"
    "kitty/kitty.conf"                     "$HOME/.config/kitty"
    "kitty/current-theme.conf"             "$HOME/.config/kitty"
    "local-bin/screenrec"                  "$HOME/.local/bin"
    "local-bin/rofi-clip"                  "$HOME/.local/bin"
    "local-bin/waybar-rec"                 "$HOME/.local/bin"
    "mako/config"                          "$HOME/.config/mako"
    "rofi/config.rasi"                     "$HOME/.config/rofi"
    "sway/config"                          "$HOME/.config/sway"
    "swaylock/config"                      "$HOME/.config/swaylock"
    "waybar/config.jsonc"                  "$HOME/.config/waybar"
    "waybar/style.css"                     "$HOME/.config/waybar"
    "xdg-desktop-portal/sway-portals.conf" "$HOME/.config/xdg-desktop-portal"
    "zsh/.zshrc"                           "$HOME"
    "zsh/.zshenv"                          "$HOME"
)

warn() { printf 'warn  %s\n' "$*" >&2; }
ok()   { printf 'ok    %s\n' "$*"; }

for ((i = 0; i < ${#setup[@]}; i += 2)); do
    rel="${setup[i]}"
    dest_dir="${setup[i + 1]}"
    src="$here/$rel"
    dest="$dest_dir/$(basename "$rel")"

    if [[ ! -e "$src" ]]; then
        warn "$rel: not in the repository, skipped"
    elif [[ -L "$dest" ]]; then
        if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
            ok "$dest already linked"
        else
            warn "$dest is a link to $(readlink "$dest"), not to $rel, left alone"
        fi
    elif [[ -e "$dest" ]]; then
        warn "$dest exists and is not a symlink, left alone"
    else
        mkdir -p "$dest_dir"
        ln -s "$src" "$dest"
        ok "$dest -> $rel"
    fi
done
