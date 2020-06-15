# vim: set ft=bashrc tw=80
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias sb='source ~/.bashrc'
alias eb='$EDITOR ~/.bashrc'
alias dot='cd ~/.dotfiles'

alias ll='ls -alF'
alias ez="$EDITOR ~/.zshrc"
alias sz='source ~/.zshrc'
alias g="git"
alias wgdl='wget --recursive --no-clobber --convert-links --html-extension --page-requisites --no-parent '

# neovim all the things
alias v="$EDITOR"
alias vim="$EDITOR"
alias vimdiff="$EDITOR -d"

# tmux
alias tmux='tmux -2'
alias ta='tmux attach-session -t 0'
alias tl='tmux list-session'

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

# just the release part, eg release_v123
function grname {
    tmp=$(gname)
    if [[ "$tmp" == "master" ]]; then
        echo "topic"
        return 0
    fi

    echo $tmp | cut -f1 -d/
}

# checkout a release branch
function gbr {
    release=$(grname)
    if [[ "$release" == "" ]]; then
        echo "error: no release" >&2
    fi
    git checkout -b "$release/$1"
}

# rebase to tip of release
function grebase {
    release=$(grname)
    if [[ $? -ne 0 ]]; then
        echo "error: no release" >&2
    fi
    git rebase "$release/current"
}
