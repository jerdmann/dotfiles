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

# just the release part, eg release_v123
function grname {
    tmp=$(gname)
    if [[ "$tmp" == "master" ]]; then
        echo "topic"
        return
    fi

    echo $tmp | cut -f1 -d/
}

# checkout a release branch
function gbr {
    release=$(grname)
    if [[ "$release" == "" ]]; then
        echo "error: no release" >&2
        return
    fi
    git checkout -b "$release/$1"
}

# rebase to tip of release
function grebase {
    release=$(grname)
    if [[ $? -ne 0 ]]; then
        echo "error: no release" >&2
        return
    fi
    git rebase "$release/current"
}

function gbump {
    python -c '
import sys, re, subprocess
r = re.search(r"(\S+)\.v(\d+)", sys.stdin.read())
if not r:
    sys.stderr.write("error: branch missing .v[number]")
    sys.exit(-1)

base = r.group(1)
tag = int(r.group(2)) + 1

branch = "{}.v{}".format(r.group(1), int(r.group(2)) + 1)
subprocess.check_call("git checkout -b {}".format(branch).split())
' < <(gname)
}
