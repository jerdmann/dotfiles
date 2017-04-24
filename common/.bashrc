# ~/.bashrc: executed by bash(1) for non-login shells#.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export EDITOR='vim'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# various shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set term type
export TERM=xterm-256color

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
    PS1="$blue$(__git_ps1 "%s") $green\W ${hasjobs:+$yellow(\j)}$green> $reset"
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

# some more aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias fixdns='sudo resolvconf -u'
alias sb='source ~/.bashrc'
alias eb='vim ~/.bashrc'
alias vcloud='~/debesys-scripts/run ~/debesys-scripts/deploy/chef/scripts/vcloud_server.py'
alias bump='~/debesys-scripts/run python ~/debesys-scripts/deploy/chef/scripts/bump_cookbook_version.py'
alias deploy='~/debesys-scripts/run python ~/debesys-scripts/deploy/chef/scripts/request_deploy.py'
alias deb='cd $(pwd | grep dev-root | cut -f1-5 -d\/) || echo "Not in a repo under dev-root."'
alias debone='cd ~/dev-root/debesys-one'
alias debtwo='cd ~/dev-root/debesys-two'
alias debthree='cd ~/dev-root/debesys-three'
alias debs='cd ~/debesys-scripts'
alias dev='cd ~/dev-root'
alias dot='cd ~/.dotfiles'
alias gvim='gvim --remote-silent'

alias tnew='tmux new-session -s '
alias tattach='tmux attach-session -t '
alias tkill='tmux kill-session -t '
alias tlist='tmux list-session'

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

# various debesys scripts
alias tempvm='~/dev-root/debesys-one/run ~/dev-root/debesys-one/deploy/chef/scripts/temp_vm.py'
alias ec2='~/dev-root/debesys-one/run ~/dev-root/debesys-one/deploy/chef/scripts/ec2_instance.py'
alias bump='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/bump_cookbook_version.py'
alias checkrepo='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/check_repo.py'
alias deploy='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/request_deploy.py'
alias build='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/request_build.py'
alias knife-ssh='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/knife_ssh.py'
alias oneoff='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/deploy_one_off.py'
alias chenv='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/change_environment.py'

alias ll='ls -alF'
alias dot='cd ~/.dotfiles'
alias gvim='gvim --remote-silent'
alias ez="vim ~/.zshrc"
alias ev="vim ~/.vimrc"
alias sz='source ~/.zshrc'
alias v="vim"
alias g="git"
alias dbd='smbclient -U jerdmann -W intad //chifs01.int.tt.local/Share'

alias tnew='tmux new-session -s '
alias tattach='tmux attach-session -t '
alias tkill='tmux kill-session -t '
alias tlist='tmux list-session'

# debesys stuff
alias ttrun='`git rev-parse --show-toplevel`/run'
alias ttpy='`git rev-parse --show-toplevel`/run python'
alias cf='cd /etc/debesys'
alias lg='cd /var/log/debesys'
function mkdeb () {
    sudo mkdir /etc/debesys 2>/dev/null || :
    sudo mkdir /var/log/debesys 2>/dev/null || :
    sudo chown jason /etc/debesys
    sudo chown jason /var/log/debesys
    sudo chmod 775 /etc/debesys
    sudo chmod 775 /var/log/debesys
}

# vcd stuff
export INTAD_USER=jerdmann
export VCD_ORG=Dev_General

export AWS_DEFAULT_REGION='us-east-1'
export JENKINS_USER='jerdmann'
export TT_EMAIL='jason.erdmann@trade.tt'

# ec2 manager name
export MGR="jerdmann"

# enable autocomplete in interactive python shells
export PYTHONSTARTUP="/home/jason/.pythonrc"

export GOPATH="/home/jason/gocode"
export PATH=/usr/local/go/bin:/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:/opt/jdk/bin:/opt/gradle/bin:$PATH
export JDK8_BIN=/opt/jdk/bin/java

# project dirs
alias debone='cd ~/dev-root/debesys-one'
alias debtwo='cd ~/dev-root/debesys-two'
alias cb='cd `git rev-parse --show-toplevel`/deploy/chef/cookbooks'
alias cdps='cd `git rev-parse --show-toplevel`/price_server'
alias cdlh='cd `git rev-parse --show-toplevel`/price_server/exchange/test_lh'
alias cdsbe='cd `git rev-parse --show-toplevel`/price_server/ps_common/sbe_messages'
alias cdpro='cd `git rev-parse --show-toplevel`/the_arsenal/all_messages/source/tt/messaging'
alias cdsmds='cd `git rev-parse --show-toplevel`/ext/linux/x86-64/release/include/smds/md-core'
alias pstest='pushd `git rev-parse --show-toplevel` && sudo ./run helmsman tt.price_server.test.suites.test_price_client && popd'

test -r ~/.keys && source ~/.keys
test -r ~/.workstation && source ~/.workstation
test -r ~/.vpn && source ~/.vpn

# jank until I figure out how computers work
setxkbmap -option ctrl:nocaps || :

# some function definitions
function cbup {
    knife cookbook --cookbook-path `git rev-parse --show-toplevel`/deploy/chef/cookbooks upload "$@"
}

function external-knife_() {
    knife "$@" -c ~/.chef/knife.external.rb
}
alias eknife='external-knife_'

alias ksj='knife search "tags:jerdmann*"'
alias ks='knife search'
alias ke='knife node edit'
alias eks='eknife search'
alias eke='eknife node edit'
alias gfix='vim $(git diff --name-only | uniq)'

function bgf {
    knife tag create $1 basegofast
}

export DEF_SEARCH_PATH="price_server synthetic_engine fixit misc the_arsenal"
function pmake {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        if [[ -z "$DEF_SEARCH_PATH" ]]; then
            echo "warning: DEF_SEARCH_PATH is unset, defaulting to entire repo"
            DEF_SEARCH_PATH="."
        fi
        pushd $reporootdir
        make -j$(nproc) def_search_path="$DEF_SEARCH_PATH" $@
        popd
    fi
}

function ptmake {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        make -j$(nproc) def_search_path="price_server fixit misc the_arsenal" price_server test_lh price_client_test
        popd
    fi
}

function sbe {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir/price_server/ps_common/sbe_messages
        SBE_JAR=$reporootdir/price_server/ps_common/sbe_messages/sbe-all.jar
        ./make_schema.sh
        cd sbe_common
        $reporootdir/run python make_enums.py
        popd
    fi
}

function makehome {
    scp ~/.vimrc "$1":~ && scp -r ~/.vim "$1":~ &>/dev/null && scp ~/.tmux.conf "$1":~
}

function rr {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        cd $reporootdir
        basedir=$(basename $PWD)
        if [[ $basedir == "ext" || $basedir == "the_arsenal" ]]; then
            cd ..
        fi
    fi
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

function servethis {
    google-chrome http://localhost:8000 &
    python -m SimpleHTTPServer 8000
}

function tohex {
    perl -e "printf (\"%x\\n\", $1)"
}

export PROJECT_DIRS="lbm price_server/ps_common price_server/price_client price_server/price_unifier synthetic_engine/composer"
function tag {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        cat /dev/null > cscope.files
        cat /dev/null > tags
        for d in $(echo $PROJECT_DIRS | tr -s " " | tr " " "\n")
        do {
            find $d -name "*.cpp" -o -name "*.h" -o -name "*.hpp" >> cscope.files
            ctags -a $d
        }; done
        cscope -bq
        popd
    fi
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
