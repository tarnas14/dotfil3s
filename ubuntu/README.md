# Ubuntu 26.04 + GNOME 50 + Forge

The same keys, shell, terminal and editor as the Arch + sway machine, on the Ubuntu install that shares this disk.
GNOME replaces everything sway did as a session: kanshi, swaylock, swayidle, waybar, mako, nm-applet, blueman, polkit agent, lid handling.
Forge tiles inside GNOME with sway's keys; rofi does the launching; kitty, zsh and nvim are the shared configs, unchanged.

## Order

```
./ubuntu/install.sh          apt, Neovim 0.12, yazi, Nerd Font, mise, Oh My Zsh, Forge, Window Calls
chsh -s /usr/bin/zsh
./ubuntu/setup.sh            symlinks (subset of ../setup.sh plus the ubuntu/ files)
./ubuntu/gnome-settings.sh   keys, workspaces, keyboard, touchpad, extensions
edit ubuntu/gitconfig.local   name, e-mail, signing key (see the top-level README)
log out, log in
mise use -g node@lts; nvim  lazy and mason install the rest
```

## What maps to what

| sway                                   | GNOME                                                                   |
| -------------------------------------- | ----------------------------------------------------------------------- |
| Super+hjkl, Super+Shift+hjkl           | Forge focus and move, same keys                                         |
| Super+b, Super+v, Super+e              | Forge split horizontal, vertical, toggle split layout                   |
| Super+s, Super+w                       | Forge stacked, tabbed                                                   |
| Super+Shift+space                      | Forge toggle float                                                      |
| Super+r resize mode                    | no modes in Forge: Super+Alt+hjkl resizes directly                      |
| Super+f, Super+Shift+x                 | GNOME fullscreen, close                                                 |
| Super+1..0, Super+Shift+1..0           | GNOME static workspaces 1 to 10 (the window does not follow the move)   |
| Super+Return, Super+d, Super+p         | kitty, `rofi -show combi`, `rofi -show win`                             |
| Super+c, Super+Shift+c, Super+period   | rofi-clip (GPaste), gpaste-client empty, rofimoji (copies only)         |
| Super+Escape, Super+Shift+Escape       | lock, suspend                                                           |
| Super+Shift+e                          | GNOME logout dialog                                                     |
| Super+n, Super+Shift+n                 | notification list, do-not-disturb toggle                                |
| Ctrl+Shift+Alt+4 / 5 / 6               | GNOME screenshot UI, full screenshot, screen recording UI               |
| gaps inner 6, smart_gaps               | Forge gap 6, hidden on single window                                    |
| client.focused colours                 | not ported: Forge focus border stays default, colours come later          |
| assign to workspaces                   | Auto Move Windows extension: brave 9, kitty 7, signal and slack 2       |
| exec lines                             | `~/.config/autostart/*.desktop`: brave, signal, slack, kitty (no keepassxc, no messenger here) |
| keepassxc in scratchpad, blueman float | no KeePassXC on this machine; Settings and pavucontrol float via `forge/windows.json` |
| Super+a focus parent, Super+space      | no equivalent, Super+a stays GNOME's app grid                           |
| Super+Shift+r reload                   | nothing to reload                                                       |
| media keys, brightness, lid            | GNOME does these                                                        |

GNOME defaults that had to move: Super+h minimize, Super+s quick settings, Super+v notifications, Super+p switch monitor, Super+l lock, Super+Escape restore shortcuts, Super+1..9 dock launchers, Ubuntu's tiling-assistant and dock (disabled).

## Where GNOME is different, and what needs a test

- **rofi on GNOME Wayland.** rofi 2.0 needs the layer-shell protocol, Mutter has none, so `rofi` alone aborts. `ubuntu/local-bin/rofi` shadows it and runs `rofi -x11 -normal-window` on XWayland. Tested 2026-09-21: plain `-x11` draws the window but Mutter never routes the keyboard to it (override-redirect window plus X grab, which Mutter refuses); `-normal-window` makes it an ordinary window that gets focus like any other, and that works. Launched apps stay Wayland because `WAYLAND_DISPLAY` is untouched. Consequences handled: Forge floats the `Rofi` class (`forge/windows.json`), `rofi-window` filters rofi out of its own list, and `center-new-windows` is on so it opens centred. Mutter's XWayland grab settings stay at their defaults.
- **rofi window mode** sees only X11 windows on GNOME, so `rofi-window` is a script mode that lists windows through the Window Calls extension over D-Bus. It shows workspace, class and title like sway's `{w} {c} {t}`.
- **Clipboard history.** Tested 2026-09-21: Mutter 50 has no data-control protocol, `wl-paste --watch` refuses to start, so cliphist is out. GPaste replaces it: Ubuntu's `gnome-shell-extension-gpaste` declares GNOME 50, the extension tracks the clipboard from inside the shell and `gpaste-client` reads it. `ubuntu/local-bin/rofi-clip` is the GPaste edition of the sway script, same key, same rofi list; `--print` returns the entry for nvim's `,p`, which now calls `rofi-clip --print` on both machines. Super+Shift+c runs `gpaste-client empty`. History is capped at 10 like `cliphist -max-items 10`. GPaste does not read KeePassXC's password hint the way the sway script did, irrelevant here since KeePassXC is not installed on this machine.
- **Workspaces on two monitors.** sway pinned 1 to 5 to the external screen and 6 to 10 to the laptop. GNOME has one workspace set that either spans both monitors (`workspaces-only-on-primary false`, what the script sets) or lives on the primary while the second monitor is static. Pick.
- **Move to workspace** does not follow the window. sway did `move container to workspace N, workspace N`.
- **Neovim** comes from the GitHub tarball (0.12), apt has 0.11. `fd` is `fdfind` on Ubuntu, the install script links it. yazi is not packaged, also from GitHub.
- **kitty** gets `hide_window_decorations yes` in the shared config, otherwise GNOME puts a title bar on it. Harmless on sway.
- **zsh** now adds `~/.local/bin` to PATH in `.zshenv`; Ubuntu only does that for bash login shells. mise installs there too.
- **git identity.** `.gitconfig` is the personal one with GPG signing and no key exists on this machine yet. Import the key, or add a work identity and `commit.gpgsign = false` for this host.
- **Signal** is not in apt or snap; brave is already installed as a snap (`brave_brave.desktop` in the Auto Move list).
- **Ergodox** wake-up udev rule from the top-level README applies here too.

## Files

| Path                          | Purpose                                                                  |
| ----------------------------- | ------------------------------------------------------------------------ |
| `install.sh`                  | packages and downloads, counterpart of `../arch-install.sh`              |
| `setup.sh`                    | symlinks, counterpart of `../setup.sh`                                   |
| `gnome-settings.sh`           | `sway/config` as gsettings and dconf                                     |
| `local-bin/rofi`              | `rofi -x11` wrapper                                                      |
| `local-bin/rofi-window`       | window switcher script mode over Window Calls                            |
| `local-bin/dnd-toggle`        | `makoctl mode -t do-not-disturb` equivalent                              |
| `rofi/config.rasi`            | imports `../rofi/config.rasi` as `base.rasi`, swaps kanshi for `win`     |
| `forge/windows.json`          | float rules, copied once (Forge rewrites the file, a symlink would not survive) |
| `autostart/*.desktop`         | the `exec` lines                                                         |
| `gitconfig.local`             | work identity, linked as `~/.gitconfig.local`; fill in name, e-mail, key |
| `kitty/current-theme.conf`    | Ubuntu kitty theme, placeholder copy of Arch's until the palette is chosen |
| `kitty/local-theme-overrides.conf` | borders, tabs, `hide_window_decorations`; last file kitty reads      |
| `nvim/host.lua`               | colourscheme for this host, loaded via `/etc/os-release`                 |
