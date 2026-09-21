#!/usr/bin/env bash
# ubuntu/setup.sh — link the parts of this repository that make sense on GNOME.
# Same loop as ../setup.sh; the sway/waybar/mako/kanshi/swaylock entries are gone,
# the ubuntu/ directory adds GNOME replacements on top.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

setup=(
    # shared
    ".gitconfig"                    "$HOME"
    ".gitignore_global"             "$HOME"
    "kitty/kitty.conf"              "$HOME/.config/kitty"
    "nvim"                          "$HOME/.config"
    "zsh/.zshrc"                    "$HOME"
    "zsh/.zshenv"                   "$HOME"
    # gnome specific
    "ubuntu/kitty/current-theme.conf"         "$HOME/.config/kitty"
    "ubuntu/kitty/local-theme-overrides.conf" "$HOME/.config/kitty"
    "ubuntu/local-bin/rofi"         "$HOME/.local/bin"
    "ubuntu/local-bin/rofi-clip"    "$HOME/.local/bin"
    "ubuntu/local-bin/rofi-window"  "$HOME/.local/bin"
    "ubuntu/local-bin/dnd-toggle"   "$HOME/.local/bin"
    "ubuntu/rofi/config.rasi"       "$HOME/.config/rofi"
    "ubuntu/rofi/onedark.rasi"      "$HOME/.config/rofi"
    "ubuntu/autostart"              "$HOME/.config"
)

warn() { printf 'warn  %s\n' "$*" >&2; }
ok()   { printf 'ok    %s\n' "$*"; }

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

# Forge rewrites its config file in place and turns a symlink into a plain file, so copy it once
forge_cfg="$HOME/.config/forge/config/windows.json"
if [[ -e "$forge_cfg" ]]; then
    ok "$forge_cfg exists, left alone (Forge owns it; diff against ubuntu/forge/windows.json by hand)"
else
    mkdir -p "$(dirname "$forge_cfg")"
    cp "$root/ubuntu/forge/windows.json" "$forge_cfg"
    ok "$forge_cfg copied from ubuntu/forge/windows.json"
fi

# links whose name differs from the file in the repository
link "$root/ubuntu/gitconfig.local" "$HOME/.gitconfig.local"
link "$root/rofi/config.rasi"       "$HOME/.config/rofi/base.rasi"
