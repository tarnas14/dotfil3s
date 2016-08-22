# tarnas14 dotfiles

This repo contains dotfiles that setup my linux environment.
For now it's just files that my programs use to look nice and work as I them to.
Maybe I will add a bootstrap script that will setup a fresh ubuntu installation, no sure.

# how to use

## linking dotfiles

1. run `make link` - dotfiles that are not present on your machine will be linked in proper places
2. profit

## neovim

1. run `./install-nvim.sh` to install neovim
2. make sure vim dotfiles are linked
3. in `nvim` install all plugins with :PlugInstall
4. run `./additionalYouCompleteMeSetup.sh` to run the plugin installation script (with tern-completer and dependency)
5. profit

# if tmux colours are not right

settig up tmux True colour was a pain in the ass, so I leave it here... it works in tmux >=2.2 (to check your version use `tmux -V`)

## testing colours in your command line

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

## configuring tmux to use true colours

solution explained here is already in the .tmux.conf (for terminals with $TERM == xterm-256color) file, but I'm leaving it here just in case
[instructions here](https://sunaku.github.io/tmux-24bit-color.html#usage)

dont bother with the patch, as mentioned it just works in tmux >=2.2
