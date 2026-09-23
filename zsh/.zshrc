# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change the frequency the auto-updater is run (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to set how old an update must be before it's applied, manually or via the auto-updater (in days).
# zstyle ':omz:update' cooldown 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose fzf mise ssh colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# unalias from .zhsrc git plugin
unalias gcmsg
function gcmsg () {
  local branchname=$(git rev-parse --abbrev-ref HEAD)

  if [[ $branchname =~ '^([a-zA-Z]+-[0-9]+)-' ]]; then
    git commit -m "${(U)match[1]} $1"
  elif [[ $branchname =~ '^([0-9]+)-' ]]; then
    git commit -m "$1"$'\n\n'"issue: #${match[1]}"
  else
    git commit -m "$1"
  fi
}

# kitty diff for git
alias gdk='git difftool --no-symlinks --dir-diff'
alias gdcak='git difftool --cached --no-symlinks --dir-diff'

alias mr='mise run'

# dx-init-wrapper-begin
dx() {
  # Find the command + subcommand, skipping any leading -v/--verbose. Plain
  # iteration over "$@" — portable across bash and zsh (no ${!var} indirection).
  local _cmd="" _sub="" _skipping=1 _arg
  for _arg in "$@"; do
    if [[ $_skipping -eq 1 && ( "$_arg" == "-v" || "$_arg" == "--verbose" ) ]]; then
      continue
    fi
    _skipping=0
    if [[ -z "$_cmd" ]]; then
      _cmd="$_arg"
    elif [[ -z "$_sub" ]]; then
      _sub="$_arg"
      break
    fi
  done
  if [[ ( "$_cmd" == "worktree" || "$_cmd" == "wt" ) && ( "$_sub" == "create" || "$_sub" == "rm" ) ]]; then
    local cdfile
    cdfile=$(mktemp "${TMPDIR:-/tmp}/dx-cd.XXXXXX") || return 1
    DX_CD_FILE="$cdfile" command dx "$@"
    local rc=$?
    if [[ $rc -eq 0 && -s "$cdfile" ]]; then
      cd "$(cat "$cdfile")"
    fi
    rm -f "$cdfile"
    return $rc
  fi
  command dx "$@"
}
# dx-init-wrapper-end
