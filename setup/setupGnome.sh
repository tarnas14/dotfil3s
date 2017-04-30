# load keyboard bindings
dconf load /org/gnome/desktop/wm/keybindings/ < ../gnome-settings/wm-keybindings.dconf.bak
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ../gnome-settings/media-keys-keybindings.dconf.bak

# setup settings
gsettings set org.gnome.shell.app-switcher current-workspace-only true
