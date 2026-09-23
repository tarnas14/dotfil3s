# Fan control on the Framework Laptop 13

Firmware runs the fans conservatively, which on this machine means audible ramping under light load.
`fw-fanctrl` replaces that curve with one of its own, and `fw-fanctrl-gui` edits it.

Three pieces, the same on both machines.
`framework_tool` from FrameworkComputer/framework-system is what actually talks to the embedded controller.
`fw-fanctrl` is the daemon and its two services, with configuration in `/etc/fw-fanctrl`.
`fw-fanctrl-gui` is the curve editor, in the app grid.

## Installing on Arch

All three are packaged with their dependencies wired up, so `arch/install.sh` carries a single AUR entry.
`fw-fanctrl-gui-bin` pulls `fw-fanctrl`, which pulls `framework-system`.

Then enable the services, which the install script lists among its manual steps:

```
sudo systemctl enable --now fw-fanctrl fw-fanctrl-suspend
```

If `framework-system-git` ever fails to build, the Ubuntu approach of dropping the upstream release binary into `/usr/bin` works here too.

## Installing on Ubuntu

Nothing is packaged, so `ubuntu/fan-control/install.sh` does the work: release binary, source build, released `.deb`.
It is deliberately not part of `ubuntu/install.sh`, because it hands the fans from firmware to a root service and that should be a decision rather than a side effect of setting up a desktop.
Re-running is safe; each piece is skipped when it is already at the latest release.

```
./ubuntu/fan-control/install.sh
```

Two flags in that script are what make the result work, and both are easy to miss when installing by hand.

`--ignore-tool framework_tool` stops the upstream installer fetching its own copy, since the script installs a newer one first.

`--effective-installation-dir /usr/local/bin` is what makes the service start at all.
The unit file templates its `ExecStart` from the installation directory, which defaults to `/usr/bin`, but `pipx --global` puts the executable in `/usr/local/bin`.
Without the override the service points at a path that does not exist.
Symlinking `/usr/bin/fw-fanctrl` to `/usr/local/bin/fw-fanctrl` fixes the symptom and is what a first manual install tends to end up with; the flag fixes the cause.
If that symlink exists from an earlier attempt it is harmless, and can be removed once the unit points at `/usr/local/bin`.

### One thing to check after a manual install

A `framework_tool` copied into `/usr/bin` by hand ends up owned by your user.
The `fw-fanctrl` unit runs it as root on stop, so a user-writable binary there means anything running as you can hand code to root.
The script corrects this on every run, not only on a fresh install.
Verify with `stat -c '%U:%G %a' /usr/bin/framework_tool`, which should read `root:root 755`.

## Using it

```
fw-fanctrl print active        # is it running the curve
fw-fanctrl print list          # available strategies
fw-fanctrl use <strategy>      # switch
fw-fanctrl reset               # hand the fans back to firmware
systemctl status fw-fanctrl
```

Strategies live in `/etc/fw-fanctrl/config.json`, which the GUI edits.
Changes to that file need `systemctl restart fw-fanctrl` unless the GUI does it for you.

## Removing it

On Arch, `yay -Rns fw-fanctrl-gui-bin fw-fanctrl framework-system-git`.

On Ubuntu the uninstall path lives in the upstream installer, so it needs the repository again:

```
sudo apt remove fw-fanctrl-gui
cd /tmp && git clone --depth 1 https://github.com/TamtamHero/fw-fanctrl.git && sudo ./fw-fanctrl/install.sh --remove
sudo rm /usr/bin/framework_tool
```

Stopping the service alone is enough to get firmware behaviour back on either machine, because the unit runs `framework_tool --autofanctrl` on stop.

## Requirements

Kernel 6.11 or newer and Python 3.12 or newer, both satisfied on Ubuntu 26.04 and on Arch.
Framework Laptop 13 only; the embedded controller interface is specific to that hardware.
