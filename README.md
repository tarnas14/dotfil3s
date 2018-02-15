# tarnas14 dockerized environment

This holds my tmux/nvim setup that I use for development. Along with node version manager and some stuff like that which I use on a daily basis.
This dockerized environment is useful mainly for web/front/server development.

## how to use

- change .gitconfig (my email, public pgp key and stuff is configured there)
- change any of the .files (tmux, zshrc, vim)
- build docker image
- .. ?
- profit

## how I use it (some binding magic)

- I run the container with some mounted/bound directories:
  - ~/.gnupg for git security
  - ~/projects (just my directory I keep my code in)
  - ~/.tmux/resurrect - directory where tmux sessions are stored by the tmux-resurrect plugin (I want that to be persisted through different container runs and host system sessions)
- bind ports to host (for things and stuff)

# other stuff

also included but probably not easily reusable:
`.cvimrc` (my settings for cvim addon for google chrome)
some scripts I use, gnome settings (not sure if reusable)
some install scripts for the 'other stuff'

// might clean this up more if I have time or some actual reason :D
