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


# set prompt
source ~/.git-prompt.sh
red="\[\e[1;31m\]"
green="\[\e[1;32m\]"
yellow="\[\e[1;33m\]"
blue="\[\e[1;34m\]"
reset="\[\e[0m\]"
PROMPT_COMMAND=_prompt_command
function _prompt_command()
{
    hasjobs=$(jobs -p)
    PS1="${SSH_CLIENT:+$yellow$HOSTNAME }$blue$(__git_ps1 "%s ")$green\w\n${hasjobs:+$yellow(\j)}$green> $reset"
    PS2="$blue>$reset"
    history -a
    history -n
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

# some more aliases
test -f ~/.bash_aliases && source ~/.bash_aliases
test -f ~/.bash_functions && source ~/.bash_functions
test -f ~/.keys && source ~/.keys

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

# vcd stuff
export INTAD_USER=jerdmann
export VCD_ORG=Dev_General

export AWS_DEFAULT_REGION='us-east-1'
export JENKINS_USER='jerdmann'
export TT_EMAIL='jason.erdmann@tradingtechnologies.com'
export TTDIAG_USER_ID='271'

#export ASAN_OPTIONS="log_path=/tmp/asan:detect_leaks=1"
#export ASAN_OPTIONS="log_path=/tmp/asan"

# ec2 manager name
export MGR="jerdmann"

export GOPATH="/home/jason/gocode"
export PATH=~/.cargo/bin:/usr/local/go/bin:/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:/opt/jdk/bin:$GOPATH/bin:/opt/node/bin:$PATH
export JDK8_BIN=/opt/jdk/bin/java

export NODEJS_HOME=/usr/local/nodejs
export PATH=$NODEJS_HOME/bin:$PATH
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

test -r ~/.keys && source ~/.keys
test -r ~/.workstation && source ~/.workstation
test -r ~/.debesys && source ~/.debesys
test -r ~/.vpn && source ~/.vpn

