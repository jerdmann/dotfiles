# Set up the prompt
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '%b '
zstyle ':vcs_info:*' enable git
precmd() {
    vcs_info
}

PROMPT='%{$fg_bold[blue]%}${vcs_info_msg_0_}%{$fg_bold[green]%}%1~ %1(j.%{$fg_bold[yellow]%}(%j%).)%{$fg_bold[green]%}>%{$reset_color%} '
if [[ -n "$SSH_CLIENT" ]]; then
    PROMPT="%{$fg_bold[yellow]%}ssh@$HOST $PROMPT"
fi

setopt histignorealldups
setopt sharehistory
setopt promptsubst

bindkey -e
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

# Fix punctuation behavior for word commands.
export WORDCHARS=''

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Use modern completion system
autoload -Uz compinit
compinit
compdef -d git

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

export EDITOR='vim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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
alias wgdl='wget --recursive --no-clobber --convert-links --html-extension --page-requisites --no-parent '

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

#export ASAN_OPTIONS="log_path=/tmp/asan:detect_leaks=1"

# ec2 manager name
export MGR="jerdmann"

# enable autocomplete in interactive python shells
export PYTHONSTARTUP="/home/jason/.pythonrc"

export GOPATH="/home/jason/gocode"
export PATH=/usr/local/go/bin:/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:/opt/jdk/bin:/opt/gradle/bin:/opt/nim-0.17.0/bin:$PATH
export JDK8_BIN=/opt/jdk/bin/java

export NODEJS_HOME=/usr/local/nodejs
export PATH=$NODEJS_HOME/bin:$PATH

# project dirs
alias r1='cd ~/dev-root/debesys-one'
alias r2='cd ~/dev-root/debesys-two'
alias cb='cd `git rev-parse --show-toplevel`/deploy/chef/cookbooks'
alias cdps='cd `git rev-parse --show-toplevel`/price_server'
alias cdlh='cd `git rev-parse --show-toplevel`/price_server/exchange/test_lh'
alias cdsbe='cd `git rev-parse --show-toplevel`/price_server/ps_common/sbe_messages'
alias cdpro='cd `git rev-parse --show-toplevel`/the_arsenal/all_messages/source/tt/messaging'
alias cdsmds='cd `git rev-parse --show-toplevel`/ext/linux/x86-64/release/include/smds/md-core'
alias pstest='pushd `git rev-parse --show-toplevel` && sudo ./run helmsman tt.price_server.test.suites.test_price_client_basic_fix && popd'
alias psatest='pushd `git rev-parse --show-toplevel` && sudo ./run helmsman tt.price_server.test.suites.test_price_client_advanced_fix && popd'

test -r ~/.keys && source ~/.keys
test -r ~/.workstation && source ~/.workstation
test -r ~/.vpn && source ~/.vpn

# some function definitions
function cbup {
    knife cookbook --cookbook-path `git rev-parse --show-toplevel`/deploy/chef/cookbooks upload "$@"
}

function external-knife_() {
    knife "$@" -c ~/.chef/knife.external.rb
}
alias eknife='external-knife_'

alias ksj='knife search "tags:jerdmann*"'
alias ke='knife node edit'
alias ksh='knife node show'
alias eke='eknife node edit'
alias eksh='eknife node show'
alias fuck='vim $(git diff --name-only | uniq)'

function ks {
    knife search "run_list:*$1* AND chef_environment:*$2*"
}

function eks {
    eknife search "run_list:*$1* AND chef_environment:*$2*"
}

function kssh {
    knife ssh -a ipaddress "run_list:*$1* AND chef_environment:*$2*" "$3"
}

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
        make -j$(nproc) price_server test_lh price_client_test price_sub price_unifier_test
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

function lbmify {
    rr
    mkdir -p build/x86-64/debug/etc/debesys
    mkdir -p build/x86-64/idebug/etc/debesys
    mkdir -p build/x86-64/release/etc/debesys
    mkdir -p build/x86-64/irelease/etc/debesys
    cp ~/lbm_license_file.txt build/x86-64/debug/etc/debesys/
    cp ~/lbm_license_file.txt build/x86-64/idebug/etc/debesys/
    cp ~/lbm_license_file.txt build/x86-64/release/etc/debesys/
    cp ~/lbm_license_file.txt build/x86-64/irelease/etc/debesys/
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

function servethis {
    google-chrome http://localhost:8000 &
    python -m SimpleHTTPServer 8000
}

function tohex {
    perl -e "printf (\"%x\\n\", $1)"
}

export PROJECT_DIRS="lbm price_server/ps_common price_server/exchange/tt_price_proxy price_server/price_client price_server/price_unifier synthetic_engine/composer test price_server/test"
function tag {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        cat /dev/null > tags
        for d in $(echo $PROJECT_DIRS | tr -s " " | tr " " "\n")
        do {
            ctags -a $d
        }; done
        popd
    fi
}

function perf-crunch {
    sudo chmod 644 perf.data && perf script > out.perf && stackcollapse-perf.pl out.perf > out.folded && sudo flamegraph.pl out.folded > perf.svg
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
