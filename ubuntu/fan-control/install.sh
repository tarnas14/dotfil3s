#!/usr/bin/env bash
# ubuntu/fan-control/install.sh — fan curve control for the Framework Laptop 13.
# Deliberately not part of ubuntu/install.sh: it hands the fans from firmware to a root
# service, which should be an explicit choice rather than a side effect of desktop setup.
# Safe to re-run; each step is skipped when already at the latest release.
set -euo pipefail

fetch() { curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors -o "$1" "$2"; }
latest_tag() { curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# python3-build is the PEP 517 frontend fw-fanctrl's installer requires; pipx because this
# Python is externally managed and the installer's default pip --prefix=/usr is refused.
sudo apt-get install -y git jq curl python3-build pipx

# framework_tool talks to the embedded controller and is not packaged anywhere. fw-fanctrl's
# unit calls it on stop to hand the fans back to firmware, so it must exist before the
# service is enabled.
fw_tag="$(latest_tag FrameworkComputer/framework-system)"
fw_have="$(framework_tool --version 2>/dev/null | awk '/Version:/ {print $2; exit}')"
if [[ "v${fw_have:-none}" != "$fw_tag" ]]; then
  echo "installing framework_tool $fw_tag"
  fetch "$tmp/framework_tool" \
    "https://github.com/FrameworkComputer/framework-system/releases/download/$fw_tag/framework_tool"
  sudo install -o root -g root -m 755 "$tmp/framework_tool" /usr/bin/framework_tool
fi

# a hand-copied framework_tool ends up owned by the user, and the fw-fanctrl unit runs it as
# root, so anything running as the user could hand code to root. Enforced on every run.
if [[ "$(stat -c '%U:%G %a' /usr/bin/framework_tool)" != "root:root 755" ]]; then
  echo "correcting ownership of /usr/bin/framework_tool"
  sudo chown root:root /usr/bin/framework_tool
  sudo chmod 755 /usr/bin/framework_tool
fi

# fw-fanctrl is source-only. --ignore-tool leaves the framework_tool installed above alone.
# --effective-installation-dir is what makes the service work: pipx --global puts the
# executable in /usr/local/bin, and without the override the unit's ExecStart is templated
# to /usr/bin and the service dies on start.
if ! systemctl list-unit-files fw-fanctrl.service >/dev/null 2>&1 || [[ "${1:-}" == "--reinstall" ]]; then
  echo "installing fw-fanctrl"
  git clone --quiet --depth 1 https://github.com/TamtamHero/fw-fanctrl.git "$tmp/fw-fanctrl"
  (cd "$tmp/fw-fanctrl" && sudo ./install.sh --pipx --ignore-tool framework_tool \
     --effective-installation-dir /usr/local/bin)
fi

# the GUI is a released .deb, no apt repository
gui_tag="$(latest_tag jslay88/fw-fanctrl-gui)"
gui_ver="${gui_tag#v}"
if [[ "$(dpkg-query -W -f='${Version}' fw-fanctrl-gui 2>/dev/null || true)" != "$gui_ver" ]]; then
  echo "installing fw-fanctrl-gui $gui_tag"
  deb="fw-fanctrl-gui_${gui_ver}_amd64.deb"
  fetch "$tmp/$deb" "https://github.com/jslay88/fw-fanctrl-gui/releases/download/$gui_tag/$deb"
  sudo apt-get install -y "$tmp/$deb"
fi

cat <<'MSG'

Done. Check with:
  systemctl status fw-fanctrl
  fw-fanctrl print active
  fw-fanctrl-gui          (also in the app grid)
MSG
