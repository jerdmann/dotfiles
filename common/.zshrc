# Set up the prompt
export TERM=xterm-256color
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

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Fix the arrow keys.
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

# Fix punctuation behavior for word commands.
export WORDCHARS=''

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Use modern completion system
autoload -Uz compinit
compinit

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

# some more aliases
alias ll='ls -alF'
alias vcloud='~/debesys-scripts/run ~/debesys-scripts/deploy/chef/scripts/vcloud_server.py'
alias newvm='~/debesys-scripts/run ~/debesys-scripts/deploy/chef/scripts/vcloud_server.py -a -s s --bootstrap'
alias ec2='~/debesys-scripts/run ~/debesys-scripts/deploy/chef/scripts/ec2_instance.py'
alias bump='~/debesys-scripts/run python ~/debesys-scripts/deploy/chef/scripts/bump_cookbook_version.py'
alias checkrepo='~/debesys-scripts/run python ~/debesys-scripts/deploy/chef/scripts/check_repo.py'
alias deploy='~/debesys-scripts/run python ~/debesys-scripts/deploy/chef/scripts/request_deploy.py'
alias build='~/debesys-scripts/run python ~/debesys-scripts/deploy/chef/scripts/request_build.py'
alias knife-ssh='~/debesys-scripts/run python ~/debesys-scripts/deploy/chef/scripts/knife_ssh.py'
alias debone='cd ~/dev-root/debesys-one'
alias debtwo='cd ~/dev-root/debesys-two'
alias debthree='cd ~/dev-root/debesys-three'
alias debscry='cd ~/scrytest/debesys-repo/scry'
alias dev='cd ~/dev-root'
alias dot='cd ~/.dotfiles'
alias gvim='gvim --remote-silent'
alias emacs='emacs -nw'
alias ez="vim ~/.zshrc"
alias sz='source ~/.zshrc'
alias dbd='smbclient -U jerdmann -W intad //chifs01.int.tt.local/Share'
alias ttpy='`git rev-parse --show-toplevel`/run python'

alias tnew='tmux new-session -s '
alias tattach='tmux attach-session -t '
alias tkill='tmux kill-session -t '
alias tlist='tmux list-session'

# debesys stuff
alias ttknife='`git rev-parse --show-toplevel`/run `git rev-parse --show-toplevel`/ttknife'
alias ttrun='`git rev-parse --show-toplevel`/run'

# vcd stuff
export INTAD_USER=jerdmann
export VCD_ORG=Dev_General

export AWS_DEFAULT_REGION='us-east-1'
export JENKINS_USER='jason.erdmann@tradingtechnologies.com'

# ec2 manager name
export MGR="jerdmann"

# enable autocomplete in interactive python shells
export PYTHONSTARTUP="/home/jason/.pythonrc"

export GOPATH="/home/jason/gocode"
export PATH=$PATH:/usr/local/go/bin

# ttnet project dirs
alias debone='cd ~/dev-root/debesys-one'
alias debtwo='cd ~/dev-root/debesys-two'
alias debthree='cd ~/dev-root/debesys-three'
alias cb='cd `git rev-parse --show-toplevel`/deploy/chef/cookbooks'

if [[ -f ~/.keys ]]; then
    . ~/.keys
fi

# capslock is useless
setxkbmap -option ctrl:nocaps 2>/dev/null

# set brightness
xbacklight -set 80 2>/dev/null || :

# some function definitions
function cbup {
    while true; do knife cookbook --cookbook-path `git rev-parse --show-toplevel`/deploy/chef/cookbooks upload "$1" && break; sleep .1; done
}

function external-knife_() {
    knife "$@" -c ~/.chef/knife.external.rb
}
alias eknife='external-knife_'

function pullscry {
	scp "$1:/opt/debesys/scry/python/tt/scryscan/*.py" /home/jason/scrytest/debesys-repo/scry/dashboard/scryscan/tt/scryscan/
	scp "$1:/opt/debesys/scry/python/tt/scrylib/*.py" /home/jason/scrytest/debesys-repo/scry/dashboard/scrylib/tt/scrylib/
	scp "$1:/opt/debesys/scry/python/tt/scryweb/*.py" /home/jason/scrytest/debesys-repo/scry/dashboard/scryweb/
}

function scrymake {
    rm -f ~/scrytest/debesys-repo/build/x86-64/debug/python/tt/scryscan/*
    rm -f ~/scrytest/debesys-repo/build/x86-64/debug/python/tt/scrylib/*
    cp -l ~/scrytest/debesys-repo/scry/dashboard/scryscan/tt/scryscan/*.py ~/scrytest/debesys-repo/build/x86-64/debug/python/tt/scryscan/
    cp -l ~/scrytest/debesys-repo/scry/dashboard/scrylib/tt/scrylib/*.py ~/scrytest/debesys-repo/build/x86-64/debug/python/tt/scrylib/
}

function scrytest {
    ttpy ~/scrytest/debesys-repo/scry/dashboard/scryscan/tests/test_data_store.py
}

function rr {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        cd $reporootdir
    fi
}

function vpn {
    sudo /home/jason/.juniper_networks/ncsvc -h us-ttvpn.tradingtechnologies.com -u jerdmann -p "$1" -r "TT VPN" -f /home/jason/.juniper_networks/tt.cert
}

function makehome {
    scp ~/.vimrc "$1":~ && scp -r ~/.vim "$1":~ &>/dev/null && scp ~/.tmux.conf "$1":~
}

function cppdoc {
    cd ~/Downloads/cppreference/reference/en.cppreference.com
    python -m SimpleHTTPServer 8000 &
    google-chrome http://localhost:8000 &
}


function external()
{
    usage="external on|off"
    if [[ -z "$1" ]]; then
        echo "$usage"
        return
    fi

    if [[ "on" == "$1" ]]; then
        export PRE_EXTERNAL_PS1=$PS1
        export PS1="%{$fg[red]%}[EXT] $PRE_EXTERNAL_PS1"
        alias ttknife='`git rev-parse --show-toplevel`/run `git rev-parse --show-toplevel`/ttknife -C ~/.chef/knife.external.rb'
        alias ttknife
        echo
        echo '######## ##     ## ######## ######## ########  ##    ##    ###    ##'
        echo '##        ##   ##     ##    ##       ##     ## ###   ##   ## ##   ##'
        echo '##         ## ##      ##    ##       ##     ## ####  ##  ##   ##  ##'
        echo '######      ###       ##    ######   ########  ## ## ## ##     ## ##'
        echo '##         ## ##      ##    ##       ##   ##   ##  #### ######### ##'
        echo '##        ##   ##     ##    ##       ##    ##  ##   ### ##     ## ##'
        echo '######## ##     ##    ##    ######## ##     ## ##    ## ##     ## ########'
        echo
        # http://patorjk.com/software/taag/#p=display&h=1&v=1&f=Banner3&t=EXTERNAL
    elif [[ "off" == "$1" ]]; then
        if [[ ! -z "$PRE_EXTERNAL_PS1" ]]; then
            export PS1=$PRE_EXTERNAL_PS1
        fi
        alias ttknife='`git rev-parse --show-toplevel`/run `git rev-parse --show-toplevel`/ttknife'
        alias ttknife
    else
        echo "$usage"
    fi
}
