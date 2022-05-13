# vim: set ft=bashrc tw=80
alias ll='ls -alF'
alias xsel='xsel -b'
alias xclip='xclip -sel clip'

alias eb="$EDITOR ~/.bashrc"
alias sb='source ~/.bashrc'
alias dot='cd ~/.dotfiles'

alias ez="$EDITOR ~/.zshrc"
alias sz='source ~/.zshrc'
alias g="git"

# neovim all the things
alias v="$EDITOR"
alias vim="$EDITOR"
alias vimdiff="$EDITOR -d"

# tmux
alias tmux='tmux -2'

# docker
alias drun='docker run -it --rm --network host'

# opens every merge-conflicted file in $EDITOR
# was originally named something else, but I wound up uttering a certain
# incantation every time I needed to use it :)
alias fuck='$EDITOR $(git diff --name-only | uniq)'

# full branch name, eg release_v123/current
alias gname='git symbolic-ref --short HEAD'
# hash of branch tip
alias ghash='git rev-parse HEAD'
