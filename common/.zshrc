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

# some more aliases
alias ll='ls -alF'
alias tempvm='~/dev-root/debesys-one/run ~/dev-root/debesys-one/deploy/chef/scripts/temp_vm.py'
alias ec2='~/dev-root/debesys-one/run ~/dev-root/debesys-one/deploy/chef/scripts/ec2_instance.py'
alias bump='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/bump_cookbook_version.py'
alias checkrepo='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/check_repo.py'
alias deploy='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/request_deploy.py'
alias build='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/request_build.py'
alias knife-ssh='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/knife_ssh.py'
alias oneoff='~/dev-root/debesys-one/run python ~/dev-root/debesys-one/deploy/chef/scripts/deploy_one_off.py'

alias dot='cd ~/.dotfiles'
alias gvim='gvim --remote-silent'
alias ez="vim ~/.zshrc"
alias ev="vim ~/.vimrc"
alias sz='source ~/.zshrc'
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
export PATH=/usr/local/go/bin:/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:$PATH

# project dirs
alias debone='cd ~/dev-root/debesys-one'
alias debtwo='cd ~/dev-root/debesys-two'
alias cb='cd `git rev-parse --show-toplevel`/deploy/chef/cookbooks'
alias cdps='cd `git rev-parse --show-toplevel`/price_server'
alias cdlh='cd `git rev-parse --show-toplevel`/price_server/exchange/test_lh'
alias cdsbe='cd `git rev-parse --show-toplevel`/price_server/ps_common/sbe_messages'
alias cdpro='cd `git rev-parse --show-toplevel`/all_messages/source/tt/messaging'
alias rr='cd `git rev-parse --show-toplevel`'
alias pstest='pushd `git rev-parse --show-toplevel` && sudo ./run helmsman tt.price_server.test.suites.test_price_client && popd'

alias cov='~/cov-analysis-linux64-8.0.0/bin/cov-run-desktop'

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

export DEF_SEARCH_PATH="price_server synthetic_engine fixit misc"
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

function sbe {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir/price_server/ps_common/sbe_messages
        SBE_JAR=$reporootdir/price_server/ps_common/sbe_messages/sbe-all.jar
        /opt/jre1.8.0_101/bin/java -Dsbe.target.language=cpp -jar $SBE_JAR ps_messages.xml
        popd
    fi
}

function makehome {
    scp ~/.vimrc "$1":~ && scp -r ~/.vim "$1":~ &>/dev/null && scp ~/.tmux.conf "$1":~
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

function servethis {
    google-chrome http://localhost:8000 &
    python -m SimpleHTTPServer 8000
}
