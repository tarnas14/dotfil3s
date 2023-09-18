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

# unalias from .zhsrc git plugin
unalias gcmsg
function gcmsg () {
  branchName=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$branchName" =~ ^[A-Za-z]+-[0-9]+- ]]; then
    jiraNumber=$(echo $branchName | grep -Eo '^[A-Za-z]+-[0-9]+-' | tr a-z A-Z)
    git commit -m "${jiraNumber::-1} $1"
  elif [[ "$branchName" =~ ^[0-9]+- ]]; then
    issueNumber=$(echo $branchName | grep -Eo '^[0-9]+-' | tr a-z A-Z)
    git commit -m "$1"$'\n\n'"issue: #${issueNumber::-1}"
  else
    git commit -m "$1"
  fi
}

export PATH=$PATH:/snap/bin

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

# PYTHON

alias pytong=python

# vimode
# bindkey -v

. /opt/asdf-vm/asdf.sh

# elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# FUNCTIONS
function d_rmi () {
  docker images | grep $1 | awk '{print $3}' | xargs -r docker rmi $@
}

function gcoB () {
  gco $(gb | grep $1)
}

function gcdt () {
  gco development
}

# find git root directory
function groot () {
  if (( $# == 0 ))
  then
    git rev-parse --show-toplevel
  else
    cd $1
    git rev-parse --show-toplevel
  fi
}

# srsly, microsoft? (.net core required to not be spied on)
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
# export MSBuildSDKsPath=/home/tarnas/.asdf/installs/dotnet-core/3.1.404/sdk/3.1.404/Sdks
# export MSBuildSDKsPath=/home/tarnas/.asdf/installs/dotnet-core/5.0.400/sdk/5.0.400/Sdks
export MSBuildSDKsPath=/home/tarnas/.asdf/installs/dotnet-core/6.0.201/sdk/6.0.201/Sdks

# https://github.com/OmniSharp/omnisharp-roslyn/issues/2131#issuecomment-848584926
export MSBuildEnableWorkloadResolver=false
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED=1

# ENV FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
# export NUGET_PAT=zmfr3a5b3npxrgq6yvvo2dd6ygxer2ccyqf6sfreg7ewmkdqzo5q
# export VSS_NUGET_EXTERNAL_FEED_ENDPOINTS='{"endpointCredentials": [{"endpoint":"https://pkgs.dev.azure.com/fincastly/functions/_packaging/Fincastly-nuget/nuget/v3/index.json", "username":"build-docker", "password":"zmfr3a5b3npxrgq6yvvo2dd6ygxer2ccyqf6sfreg7ewmkdqzo5q"}]}'

export GPG_TTY=$(tty)

# erlang
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

# for entity framework core
export PATH="$PATH:~/.dotnet/tools"

function cleancache() {
  echo 'cleaning docker containers'
  docker ps -a | grep -v Up | awk '{print $1}' | xargs docker rm -f
  echo 'cleaning docker system'
  docker system prune -f
  echo 'cleaning docker volumes'
  docker volume prune -f
  echo 'clean yarn cache?'
  echo 'press anything to continue, ^c to stop'
  read -n 1
  echo 'cleaning yarn'
  yarn cache clean --all
  echo 'done'
  echo 'clean spotify cache?'
  echo 'press anything to continue, ^c to stop'
  read -n 1
  echo 'cleaning spotify'
  rm -rf ~/.cache/spotify/Data/
  mkdir ~/.cache/spotify/Data
  echo 'done'
  echo 'next are sudo commands (journal and yay)'
  echo 'press anything to continue, ^c to stop'
  read -n 1
  echo 'cleaning journalctl'
  sudo journalctl --vacuum-size=100M
  echo 'done'
  echo 'cleaning yay cache'
  yay -Sc
  echo 'done'
}

export NEXT_TELEMETRY_DISABLED=1

eval "$(direnv hook zsh)"

function kittyP() {
  nohup kitty --session project.conf & disown
  nohup kitty --session dockers.conf & disown
  exit
}
