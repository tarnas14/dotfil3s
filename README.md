# tarnas14 dotfiles

This repo contains dotfiles that setup my linux environment.
For now it's just files that my programs use to look nice and work as I them to.
Maybe I will add a bootstrap script that will setup a fresh ubuntu installation, no sure.

# how to use

## linking dotfiles

1. run `make link` - dotfiles that are not present on your machine will be linked in proper places
2. profit

## nvim and dependencies

1. run `./letsgo.sh` to install neovim and other programs (used by nvim)
2. make sure vim dotfiles are linked
3. in `nvim` install all plugins with :PlugInstall
4. run `./setup-plugins.sh` to install additional dependencies that nvim plugins need
5. profit

## using [/scripts](#scripts)

`make link` target links a `~/scripts` directory on your machine - this contains scripts that might come in handy

obviously to make them available globally you might want to add the `~/scripts` directory to your PATH

# tmux

## installing tmux 2.2
[see here](https://pseudoscripter.wordpress.com/2016/05/28/installing-tmux-2-2/)

## if tmux colours are not right

settig up tmux True colour was a pain in the ass, so I leave it here... it works in tmux >=2.2 (to check your version use `tmux -V`)

### testing colours in your command line

to check whether your terminal supports true colours run below script (you should see a sweet rainbow gradient if true colours are enabled)

```
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
```

### configuring tmux to use true colours

solution explained here is already in the .tmux.conf (for terminals with $TERM == xterm-256color) file, but I'm leaving it here just in case
[instructions here](https://sunaku.github.io/tmux-24bit-color.html#usage)

dont bother with the patch, as mentioned it just works in [tmux >=2.2](#installing-tmux-2.2)

# scripts

## cat-on-laptop

when at my desk I'm using an external keyboard and mouse, so the laptop keyboard and touchpad is used ONLY when my cat sits there. . . 

`cat-on-laptop.sh --off` turn the keyboard and touchpad off to prevent cat input

`cat-on-laptop.sh --on` turn the keyboard and touchpad back on

the script assumes the presence of `~/.catonlaptop` config file with specific options

it is a very crude option list that allows following 4 options; notice the escaped `/` sign - the string after `:` in each line is used in a regex

```
keyboard-master:Virtual core keyboard
keyboard:AT Translated Set 2 keyboard
pointer-master:Virtual core pointer
touchpad:ETPS\/2 Elantech Touchpad
```

these values can be found by running `xinput list` and finding your keyboard and pointer master and specific keyboard and pointerslaves
