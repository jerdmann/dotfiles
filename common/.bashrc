# ~/.bashrc: executed by bash(1) for non-login shells#.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export EDITOR='nvim'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# various shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=2000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

PROMPT_COMMAND=__ps1
if [ -r ~/.git-prompt ]; then
    source ~/.git-prompt
else
    function __git_ps1() { echo "" ; }
fi
function __ps1()
{
    local red='\[\e[1;31m\]'
    local green='\[\e[1;32m\]'
    local yellow='\[\e[1;33m\]'
    local blue='\[\e[1;34m\]'
    local reset='\[\e[0m\]'
    PS1="${SSH_CLIENT:+$yellow$HOSTNAME }$blue$(__git_ps1 "%s ")$green\W > $reset"
    PS2="$blue>$reset"
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# stole this from default raspberry pi bashrc
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LIBRARY_PATH="/usr/lib/x86_64-linux-gnu"
export LD_LIBRARY_PATH="/usr/local/include"

export GOPATH="/home/jason/gocode"
export PATH=~/.cargo/bin:/usr/local/go/bin:/opt/jdk/bin:$GOPATH/bin:$PATH

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

for f in \
    ~/.ase_rc \
    ~/.bash_aliases \
    ~/.bash_functions \
    ~/.debesys \
    ~/.keys \
    ~/.vpn \
    ~/.workstation \
; do
    test -r $f && source $f
done

CDPATH=""
for n in one two three; do
    dev="/home/jason/dev-root"
    CDPATH="$CDPATH:$dev/debesys-$n/mds/exchange_adapter"
    CDPATH="$CDPATH:$dev/debesys-$n/mds/consumer"
done
# remove the first colon
export CDPATH=$(echo $CDPATH | sed 's/://')
CDPATH="/home/jason/projects:$CDPATH"

export RIPGREP_CONFIG_PATH=~/.rgrc

# try keyboard settings, ignore failures
setxkbmap -option ctrl:nocaps 2>/dev/null || :
xset r rate 200 30 2>/dev/null || :

# only one xcape
pidof xcape >/dev/null 2>&1
if [[ $? -eq 1 ]]; then
    xcape -t 200 2>/dev/null
fi
