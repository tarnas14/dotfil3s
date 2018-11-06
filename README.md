# always work in progress

Every time I ask somebody about their dotfiles repo I hear something along the lines of "I've been planning to clean it up a bit"

Yes, I've also been planning to clean my dotfiles a bit... And I will get round to it eventually...
Oh and I just noticed that I already said that in the last line of this readme... smh

# tarnas14 dockerized environment

This holds my tmux/nvim setup that I use for development. Along with node version manager and some stuff like that which I use on a daily basis.
This dockerized environment is useful mainly for web/front/server development.

The entrypoint is just zsh, because I want to have the flexibility between running just nvim inside host tmux session or an entire tmux session inside host terminal.

The goal is to reach a solution that will allow seamless switching between host and dockerized tools and processes, probably via some binding magic I don't yet know how to use...

## how to use

- change .gitconfig (my email, public pgp key and stuff is configured there)
- change any of the .files (tmux, zshrc, vim)
- build docker image
- .. ?
- profit

## how I use it (some binding magic)

# see ./startEnv.sh

- I run the container with some mounted/bound directories:
  - ~/.gnupg for git security
  - ~/.tmux/dockerized-resurrect - host directory where tmux sessions are stored by the tmux-resurrect plugin (I want that to be persisted through different container runs and host system sessions)
  - ~ some directories I want to be able to edit (like my todos, my projects directories and stuff)
- bind ports to host (for things and stuff)

# other stuff

also included but probably not easily reusable:
`.cvimrc` (my settings for cvim addon for google chrome)
some scripts I use, gnome settings (not sure if reusable)
some install scripts for the 'other stuff'

// might clean this up more if I have time or some actual reason :D
