#!/bin/bash

# dependencies
sudo pacman -S --needed --noconfirm scrot
sudo pacman -S --needed --noconfirm rofi
sudo pacman -S --needed --noconfirm dmenu
sudo pacman -S --needed --noconfirm feh
sudo pacman -S --needed --noconfirm playerctl
sudo pacman -S --needed --noconfirm polybar
#!/bin/bash

. ./utils.sh

rm -f ~/.onedark-theme.rasi
ln -s ~/dotfil3s/i3/onedark-theme.rasi ~/onedark-theme.rasi
rm -rf ~/.config/i3
ln -s ~/dotfil3s/i3 ~/.config/i3
rm -rf ~/.config/polybar
ln -s ~/dotfil3s/polybar ~/.config/polybar
