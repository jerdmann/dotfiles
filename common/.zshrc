# Set up the prompt
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '%b '
zstyle ':vcs_info:*' enable git
precmd() {
    vcs_info
}

if [[ -n "$_DOCKER" && -z "$TMUX" ]]; then
    export TMUX='docker-tmux-spoof'
fi

PROMPT='%{$fg_bold[blue]%}${vcs_info_msg_0_}%{$fg_bold[green]%}%1~ %1(j.%{$fg_bold[yellow]%}(%j%).)%{$fg_bold[green]%}>%{$reset_color%} '
if [[ -n "$SSH_CLIENT" ]]; then
    PROMPT="%{$fg_bold[yellow]%}ssh@$HOST $PROMPT"
fi

setopt histignorealldups
setopt sharehistory
setopt promptsubst
setopt aliases

# how on earth is this not the default
unsetopt equals

bindkey -e
bindkey "^[[1;5D" emacs-backward-word
bindkey "^[[1;5C" emacs-forward-word

# Fix punctuation behavior for word commands.
export WORDCHARS=''

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt auto_cd
CDPATH=""
for n in one two three; do
    dev="/home/jason/dev-root"
    CDPATH="$CDPATH:$dev/debesys-$n/mds/exchange_adapter"
    CDPATH="$CDPATH:$dev/debesys-$n/mds/consumer"
done
# remove the first colon
export CDPATH=$(echo $CDPATH | sed 's/://')

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Use modern completion system
autoload -Uz compinit
compinit
compdef -d git

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

autoload zmv

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

#export ASAN_OPTIONS="log_path=/tmp/asan:detect_leaks=1"
#export ASAN_OPTIONS="log_path=/tmp/asan"

export GOPATH="/home/jason/gocode"
export PATH=~/.cargo/bin:/usr/local/go/bin:/opt/jdk/bin:/opt/nim-1.0.0/bin:$GOPATH/bin:~/node/bin:$PATH
export JDK8_BIN=/opt/jdk/bin/java

export RIPGREP_CONFIG_PATH=~/.rgrc

my_dotfiles=(
~/.bash_aliases
~/.bash_functions
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
xset r rate 200 30 2>/dev/null || :

# only one xcape
pidof xcape >/dev/null 2>&1
if [[ $? -eq 1 ]]; then
    xcape -t 200 2>/dev/null
fi
