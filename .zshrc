# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git npm)

# User configuration

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH=$PATH:/snap/bin

if [ -z "$TMUX" ]; then
  tmux attach || tmux new
fi

alias vtop="vtop --theme wizard"
export EDITOR="nvim"
export MYVIMRC="~/.config/nvim/init.vim"

_has() {
  return $( whence $1 >/dev/null )
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if _has fzf && _has ag; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# java [*]

export JAVA_HOME=~/devtools/java/jdk1.8.0_162
export PATH=$PATH:~/devtools/java/jdk1.8.0_162/bin

export ANT_HOME=~/devtools/ant/apache-ant-1.9.11
export PATH=$PATH:~/devtools/ant/apache-ant-1.9.11/bin

# https://stackoverflow.com/questions/47150410/failed-to-run-sdkmanager-list-android-sdk-with-java-9
# WTF I hate java
export ANDROID_HOME=~/devtools/android/
export PATH=$PATH:~/devtools/android/platform-tools
export PATH=$PATH:~/devtools/android/tools

export PATH=$PATH:~/devtools/gradle-4.6/bin

# PYTHON

alias pytong=python

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# vimode
# bindkey -v

. $HOME/.asdf/asdf.sh

# elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# FUNCTIONS
function d_rmi () {
  docker images | grep $1 | awk '{print $3}' | xargs -r docker rmi
}

function gcoB () {
  gco $(gb | grep $1)
}

function groot () {
  if (( $# == 0 ))
  then
    git rev-parse --show-toplevel
  else
    cd $1
    git rev-parse --show-toplevel
  fi
}

# dockerized environment

function denv () {
  gitRoot=$(groot $PWD)
  name=$(basename $gitRoot)

  if (( $# == 0 ))
  then
    docker run -it --rm --name $name --hostname $name -v $gitRoot:/home/tarnas-dev-env/code tarnas-dev-env:core
  else
    docker run -it --rm --name $name --hostname $name -v $gitRoot:/home/tarnas-dev-env/code tarnas-dev-env:$1
  fi
}

function dvim () {
  gitRoot=$(groot $PWD)
  name="$(basename $gitRoot)-name"

  if (( $# == 0 ))
  then
    docker run -it --rm --name $name --hostname $name -v $gitRoot:/home/tarnas-dev-env/code tarnas-dev-env:core /bin/zsh -c "nvim"
  else
    docker run -it --rm --name $name --hostname $name -v $gitRoot:/home/tarnas-dev-env/code tarnas-dev-env:$1 /bin/zsh -c "nvim"
  fi
}

# srsly, microsoft? (.net core required to not be spied on)
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
