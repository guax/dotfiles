# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

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
plugins=(git z history grunt colorize bower)

source $ZSH/oh-my-zsh.sh

PROMPT="%{$FG[241]%}$(hostname)%{$reset_color%} $PROMPT"

# User configuration

export PATH=$PATH:~/bin
# export MANPATH="/usr/local/man:$MANPATH"

export PATH=$PATH:~/src/go/bin
export PATH=~/.npm-global/bin:$PATH

if [ "${GOPATH}" = "" ]; then
    export GOPATH=~/src/go
else
    export GOPATH=$GOPATH:~/src/go
fi


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

if [ -e /etc/slackware-version ]; then
    # If we're on slackware we want i3 to open konsole instead of xterm
    export TERMINAL=konsole
fi

# Wish I could learn emacs
export EDITOR=vim

export LESS=-R

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


alias eh='sudo vim /etc/hosts'
if type gsort > /dev/null; then
    # Mac OSX with correct GNU sort installed
    alias ds='du -hs * | gsort -h'
else
    alias ds='du -hs * | sort -h'
fi
alias df='df -h'

alias kb='keybase'
# GIT aliases
alias gdc='git diff --cached'
alias gadd='git add'

# Docker aliases
alias dm='docker-machine'
alias dc='docker-compose'

# custom thefuck loading if installed
if [ -n $commands[thefuck] ]; then
    # Register alias
    alias fuck=thefuck

    fuck-command-line() {
        local FUCK="$(THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
        [[ -z $FUCK ]] && echo -n -e "\a" && return
        BUFFER=$FUCK
        zle end-of-line
    }
    zle -N fuck-command-line
    # Defined shortcut keys: [Esc] [Esc]
    bindkey "\e\e" fuck-command-line
fi

# Loading custom configuration, specific to machine or proprietary of your company
CUSTOM_FILE=~/.zshrc-custom
if [ -r $CUSTOM_FILE ]; then
    source $CUSTOM_FILE
fi

source .functions

ssha() {
    ssh-add -l &>/dev/null
    if [ "$?" -eq "2" ]; then
      test -r ~/.ssh-agent && \
        eval "$(<~/.ssh-agent)" >/dev/null

      ssh-add -l &>/dev/null
      if [ "$?" -eq "2" ]; then
        (umask 066; ssh-agent > ~/.ssh-agent)
        eval "$(<~/.ssh-agent)" >/dev/null
        ssh-add -t300
      fi
    fi
}

addkey() {
    ssha
    ssh-add -t300 ~/.ssh/$1
}
