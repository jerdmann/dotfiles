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

unsetopt equals

bindkey -e
bindkey "^[[1;5D" emacs-backward-word
bindkey "^[[1;5C" emacs-forward-word

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

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

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

export EDITOR='nvim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# stole this from default raspberry pi bashrc
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# some more aliases
test -f ~/.bash_aliases && source ~/.bash_aliases
test -f ~/.bash_functions && source ~/.bash_functions
test -f ~/.keys && source ~/.keys

export LIBRARY_PATH="/usr/lib/x86_64-linux-gnu"
export LD_LIBRARY_PATH="/usr/local/lib"

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
export PATH=~/.cargo/bin:/usr/local/go/bin:/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:/opt/jdk/bin:/opt/gradle/bin:/opt/nim-0.17.0/bin:$GOPATH/bin:$PATH
export JDK8_BIN=/opt/jdk/bin/java

export NODEJS_HOME=/usr/local/nodejs
export PATH=$NODEJS_HOME/bin:$PATH
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

my_dotfiles=(
~/.debesys
~/.keys
~/.vpn
~/.workstation
)
for f in $my_dotfiles; do
    test -r $f && source $f
done

# try keyboard settings, ignore failures
setxkbmap -option ctrl:nocaps 2>/dev/null || :
xcape 2>/dev/null || :
xset r rate 200 25 2>/dev/null || :
