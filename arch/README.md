# Arch + sway

The original setup. From the repository root: `./arch/install.sh` for packages (repos and AUR through
yay), `./arch/setup.sh` for the symlinks, then the manual steps the install script prints
(services, `chsh -s /usr/bin/zsh`, Oh My Zsh, log out and in).

Per-host files here: `gitconfig.local` (personal identity and signing key), `kitty/current-theme.conf`
and `kitty/local-theme-overrides.conf` (Base2Tone Desert Dark, borders and tabs in the sway colours),
`nvim/host.lua` (melange), `rofi/config.rasi` (imports the shared `base.rasi`). `gitconfig-personal`
is a second identity with its own ssh alias; nothing here includes it, add an `includeIf` to
`gitconfig.local` if it is meant to apply to a directory.
