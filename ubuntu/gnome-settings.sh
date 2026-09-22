#!/usr/bin/env bash
# ubuntu/gnome-settings.sh — sway/config translated to GNOME + Forge, applied with gsettings and dconf.
# Re-runnable. Log out and in afterwards so newly installed extensions load.
set -euo pipefail

wm=org.gnome.desktop.wm.keybindings
shell=org.gnome.shell.keybindings
mutter=org.gnome.mutter.keybindings
media=org.gnome.settings-daemon.plugins.media-keys
bin="$HOME/.local/bin"

### Input, like sway's input blocks
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
gsettings set org.gnome.desktop.peripherals.keyboard delay 250
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 25       # 40/s
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'    # clickfinger
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true # dwt
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.2
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'              # focus_follows_mouse no

### Appearance
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11'
# no colours or themes here on purpose: this machine gets its own scheme once everything works

### Lock after 5 minutes like swayidle
gsettings set org.gnome.desktop.session idle-delay 300
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.screensaver lock-delay 0

### Workspaces: ten static ones, spanning both monitors so Super+N switches everything
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.mutter edge-tiling false   # Forge tiles, mutter should not
gsettings set org.gnome.mutter center-new-windows true   # rofi is a normal window on GNOME, open it centred

### rofi runs with -normal-window, X11 grabs stay off (undoes the test settings)
gsettings reset org.gnome.mutter.wayland xwayland-allow-grabs
gsettings reset org.gnome.mutter.wayland xwayland-grab-access-rules

### A bare Super press opens the overview; easy to hit by accident, so the overview moves to Super+m
gsettings set org.gnome.mutter overlay-key ''
gsettings set $shell toggle-overview "['<Super>m']"

### Free the keys sway uses from GNOME's defaults
gsettings set $wm minimize "[]"                          # Super+h -> focus left
gsettings set $wm show-desktop "['<Primary><Super>d', '<Primary><Alt>d']"   # Ubuntu puts show-desktop on Super+d -> launcher
gsettings set $wm switch-input-source-backward "['<Shift>XF86Keyboard']"    # Shift+Super+space -> Forge float toggle
gsettings set $shell toggle-quick-settings "[]"          # Super+s -> stacking
gsettings set $shell toggle-message-tray "['<Super>n']"  # Super+v -> splitv, Super+n shows/hides notifications
gsettings set $shell focus-active-notification "[]"
gsettings set $mutter switch-monitor "['XF86Display']"   # Super+p -> window switcher
gsettings set org.gnome.mutter.wayland.keybindings restore-shortcuts "[]"  # Super+Escape -> lock
gsettings set $mutter cancel-input-capture "[]"           # Super+Shift+Escape -> suspend
gsettings set $mutter toggle-tiled-left "[]"             # Super+arrows do nothing, on sway too
gsettings set $mutter toggle-tiled-right "[]"
for d in left right up down; do gsettings set $wm move-to-monitor-$d "[]"; done   # Super+Shift+arrows do nothing either
gsettings set $media screensaver "['<Super>Escape']"     # frees Super+l
gsettings set $media logout "['<Super><Shift>e']"
for n in 1 2 3 4 5 6 7 8 9; do
  gsettings set $shell switch-to-application-$n "[]"     # Super+N launches dock apps by default
done
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false 2>/dev/null || true

### Workspaces and windows, same keys as sway
for n in 1 2 3 4 5 6 7 8 9; do
  gsettings set $wm switch-to-workspace-$n "['<Super>$n']"
  gsettings set $wm move-to-workspace-$n "['<Super><Shift>$n']"
done
gsettings set $wm switch-to-workspace-10 "['<Super>0']"
gsettings set $wm move-to-workspace-10 "['<Super><Shift>0']"
gsettings set $wm close "['<Super><Shift>x']"
gsettings set $wm toggle-fullscreen "['<Super>f']"

### Screenshots and recording: GNOME's built in UI on the old chords
gsettings set $shell show-screenshot-ui "['Print', '<Ctrl><Shift><Alt>4']"
gsettings set $shell screenshot "['<Shift>Print', '<Ctrl><Shift><Alt>5']"
gsettings set $shell show-screen-recording-ui "['<Ctrl><Shift><Alt>R', '<Ctrl><Shift><Alt>6']"

### Custom launch bindings (sway exec lines)
custom_base=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
declare -a custom_paths=()
i=0
bind() { # name, command, binding
  local path="$custom_base/custom$i/"
  dconf write "$path"name "'$1'"
  dconf write "$path"command "'$2'"
  dconf write "$path"binding "'$3'"
  custom_paths+=("'$path'")
  i=$((i + 1))
}
bind "terminal"           "kitty"                                        "<Super>Return"
bind "launcher"           "$bin/rofi -show combi"                        "<Super>d"
bind "windows"            "$bin/rofi -show win"                          "<Super>p"
bind "clipboard history"  "$bin/rofi-clip"                               "<Super>c"
bind "clipboard wipe"     "gpaste-client empty"                          "<Super><Shift>c"
bind "emoji"              "rofimoji --selector rofi --action copy"       "<Super>period"
bind "suspend"            "systemctl suspend"                            "<Super><Shift>Escape"
bind "do not disturb"     "$bin/dnd-toggle"                              "<Super><Shift>n"
gsettings set $media custom-keybindings "[$(IFS=,; echo "${custom_paths[*]}")]"

### Forge: keys from sway/config. dconf works before the extension has loaded.
fk=/org/gnome/shell/extensions/forge/keybindings
fkey() { dconf write "$fk/$1" "$2"; }
fkey window-focus-left            "['<Super>h']"
fkey window-focus-down            "['<Super>j']"
fkey window-focus-up              "['<Super>k']"
fkey window-focus-right           "['<Super>l']"
fkey window-move-left             "['<Shift><Super>h']"
fkey window-move-down             "['<Shift><Super>j']"
fkey window-move-up               "['<Shift><Super>k']"
fkey window-move-right            "['<Shift><Super>l']"
fkey con-split-horizontal         "['<Super>b']"
fkey con-split-vertical           "['<Super>v']"
fkey con-split-layout-toggle      "['<Super>e']"
fkey con-stacked-layout-toggle    "['<Super>s']"
fkey con-tabbed-layout-toggle     "['<Super>w']"
fkey window-toggle-float          "['<Shift><Super>space']"
# sway's resize mode has no Forge equivalent; grow/shrink directly with Super+Alt
fkey window-resize-right-increase  "['<Alt><Super>l']"
fkey window-resize-right-decrease  "['<Alt><Super>h']"
fkey window-resize-bottom-increase "['<Alt><Super>j']"
fkey window-resize-bottom-decrease "['<Alt><Super>k']"
# Forge defaults that collide with the keys above
fkey prefs-tiling-toggle          "['<Shift><Super>w']"   # was Super+w
fkey workspace-active-tile-toggle "@as []"                # was Shift+Super+w
fkey window-swap-last-active      "@as []"                # was Super+Return
fkey window-toggle-always-float   "@as []"                # was Shift+Super+c
fkey prefs-open                   "@as []"                # was Super+period
fkey focus-border-toggle          "@as []"                # was Super+x, one key off Super+Shift+x (close); toggled the border off by accident
# left alone: Ctrl+Super+hjkl swap, Ctrl+Super+plus/minus gaps

f=/org/gnome/shell/extensions/forge
dconf write $f/window-gap-size 6                       # gaps inner 6
dconf write $f/window-gap-hidden-on-single true        # smart_gaps on
dconf write $f/focus-border-toggle true              # Super+x flips this off; keep it on

# Border colours and size live in Forge's stylesheet, not in dconf (the focus-border-*
# dconf keys are not read by the extension). Forge writes the file on first enable;
# on a fresh machine run this script again after the first login. One Dark palette,
# 2px and square like the sway/kitty borders.
css="$HOME/.config/forge/stylesheet/forge/stylesheet.css"
if [[ -f "$css" ]]; then
  border() { # class, rgba
    sed -i -E "/^\.$1 \{/,/^\}/{s/border-color:[^;]+;/border-color: $2;/;s/border-width:[^;]+;/border-width: 2px;/;s/border-radius:[^;]+;/border-radius: 0px;/}" "$css"
  }
  border window-tiled-border   "rgba(86, 182, 194, 1)"    # cyan   #56b6c2, focused window
  border window-stacked-border "rgba(229, 192, 123, 1)"   # yellow #e5c07b
  border window-tabbed-border  "rgba(97, 175, 239, 1)"    # blue   #61afef
  border window-floated-border "rgba(198, 120, 221, 1)"   # purple #c678dd
  # flipping css-updated makes the running extension reload the stylesheet
  if [[ "$(dconf read $f/css-updated)" == "true" ]]; then dconf write $f/css-updated false; else dconf write $f/css-updated true; fi
else
  echo "note: $css not there yet, Forge creates it on first enable; re-run for the border colours"
fi

### GPaste: clipboard history like cliphist -max-items 10 (schema comes with gpaste-2)
if gsettings list-schemas | grep -qx org.gnome.GPaste; then
  gsettings set org.gnome.GPaste max-history-size 10
  gsettings set org.gnome.GPaste images-support true
  gsettings set org.gnome.GPaste track-changes true
  # GPaste's own Ctrl+Alt global shortcuts would steal keys from apps; rofi is the only interface here
  for k in show-history pop make-password launch-ui sync-clipboard-to-primary sync-primary-to-clipboard upload; do
    gsettings set org.gnome.GPaste $k "''"
  done
fi

### Notifications: GNOME Shell replaces mako. Banners top-right like mako; per-app switches
### live in Settings > Notifications (dconf /org/gnome/desktop/notifications/application/<id>/enable)
dconf write /org/gnome/shell/extensions/notification-position/position "'top-right'"
dconf write /org/gnome/shell/extensions/notification-position/show-indicator false

### Top bar: clock on the right between the tray icons and quick settings, like waybar.
### Items not listed stay where GNOME puts them; unlisted tray icons sit left of the listed ones.
dconf write /org/gnome/shell/extensions/top-bar-organizer/right-box-order "['dateMenu', 'quickSettings']"
dconf write /org/gnome/shell/extensions/top-bar-organizer/center-box-order "@as []"

### Window to workspace rules (sway assign), via the Auto Move Windows extension
dconf write /org/gnome/shell/extensions/auto-move-windows/application-list \
  "['brave_brave.desktop:9', 'kitty.desktop:7', 'signal-desktop.desktop:2', 'slack_slack.desktop:2', 'messenger.desktop:2', 'spotify_spotify.desktop:10']"

### Extensions: tiling-assistant and the dock fight with a tiler
enabled=(
  forge@jmmaranan.com
  window-calls@domandoman.xyz
  auto-move-windows@gnome-shell-extensions.gcampax.github.com
  GPaste@gnome-shell-extensions.gnome.org
  notification-position@drugo.dev
  top-bar-organizer@julian.gse.jsts.xyz
  ubuntu-appindicators@ubuntu.com
  ding@rastersoft.com
)
gsettings set org.gnome.shell enabled-extensions "[$(printf "'%s'," "${enabled[@]}" | sed 's/,$//')]"
gsettings set org.gnome.shell disabled-extensions "['tiling-assistant@ubuntu.com', 'ubuntu-dock@ubuntu.com']"

echo "applied. Log out and back in for the extensions."
