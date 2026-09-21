# always work in progress

Every time I ask somebody about their dotfiles repo I hear something along the lines of "I've been planning to clean it up a bit"

Yes, I've also been planning to clean my dotfiles a bit... And I will get round to it eventually...
Oh and I just noticed that I already said that in the last line of this readme... smh

## Layout

One repository, two machines that share it: a private Arch + sway system and an Ubuntu 26.04 +
GNOME 50 work system, dual-booted on the same laptop with this checkout on a shared partition.

| Path       | Holds                                                                                   |
| ---------- | --------------------------------------------------------------------------------------- |
| root       | shared configs: `kitty/kitty.conf`, `nvim/`, `zsh/`, `rofi/config.rasi`, `.gitconfig`, `ergodox/` |
| `arch/`    | sway, waybar, mako, kanshi, swaylock, portals, sway helper scripts, `install.sh`, `setup.sh` |
| `ubuntu/`  | GNOME + Forge keybindings, rofi wrappers, GPaste clipboard, autostart, `install.sh`, `setup.sh`, `gnome-settings.sh` |

Fresh machine: `./<host>/install.sh`, then `./<host>/setup.sh`, then the host README.

## How per-host differences are handled

Both systems read the same files, so anything inside the repository is shared by definition.
Only `$HOME` differs. Two rules follow from that:

1. **Shared file holds the value that is right on Arch today; a host file overrides only the keys
   that differ.** The host's `setup.sh` links the host file into `$HOME` under a fixed name that the
   shared file includes *after* its own settings, so the host value wins. Used for:

   | fixed name in `$HOME`                        | shared file that includes it | host file                              |
   | -------------------------------------------- | ---------------------------- | -------------------------------------- |
   | `~/.gitconfig.local`                         | `.gitconfig` `[include]`     | `<host>/gitconfig.local` (identity, signing key) |
   | `~/.config/kitty/current-theme.conf`         | `kitty/kitty.conf`           | `<host>/kitty/current-theme.conf`      |
   | `~/.config/kitty/local-theme-overrides.conf` | `kitty/kitty.conf`, last line | `<host>/kitty/local-theme-overrides.conf` (borders, tabs, sizes, decorations) |
   | `~/.config/rofi/config.rasi`                 | imports `~/.config/rofi/base.rasi` = `rofi/config.rasi` | `<host>/rofi/config.rasi` (modes, font size, theme) |

2. **Where a whole directory is one symlink, detect the host at runtime.** `~/.config/nvim` links to
   `nvim/`, so `nvim/lua/config/host.lua` reads `ID` from `/etc/os-release` and loads
   `<repo>/<id>/nvim/host.lua` (colourscheme and anything else that differs).

No environment variable: `.zshenv` is shared too, and applications started by the session would not
see it anyway.

Pending overrides that follow the same rule: rofi's font is too small on GNOME's scale, so
`font:` goes into the `configuration {}` block of `ubuntu/rofi/config.rasi`; the Ubuntu colour
palette goes into `ubuntu/kitty/*`, `ubuntu/nvim/host.lua` and Forge's border colour in
`ubuntu/gnome-settings.sh`. Window borders and startup applications are per host by nature
(`arch/sway/config` versus `ubuntu/gnome-settings.sh` and `ubuntu/autostart/`).

## gpg password prompt inline

https://stackoverflow.com/questions/41052538/git-error-gpg-failed-to-sign-data#answer-61314861

## allowing the ergo dox keyboard to wakeup the laptop:
# /etc/udev/rules.d/90-usb-wakeup.rules
ACTION=="add", SUBSYSTEM="usb", ATTRS{idVendor}=="feed", ATTRS{idProduct}=="1307", ATTR{power/wakeup}="enabled"
