# vim: set ft=bashrc
function cbup {
    knife cookbook --cookbook-path `git rev-parse --show-toplevel`/deploy/chef/cookbooks upload "$@"
}

export _wk_container_name=rusty_manticore
function wkbuild {
    docker build --network=host --tag debesys:latest \
                           --build-arg user=$(id -un) \
                           --build-arg userid=$(id -u) \
                           --build-arg repodir=/home/jason/dev-root \
                           .
}

function wkrun {
    docker run $@ --name=$_wk_container_name \
        --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
        --mount src=/home/jason/dev-root,target=/home/jason/dev-root,type=bind \
        --mount src=/etc/debesys,target=/etc/debesys,type=bind \
        --mount src=/home/jason/.dotfiles,target=/home/jason/.dotfiles,type=bind \
        debesys:latest
}

function servethis {
    google-chrome http://localhost:8000 &
    python -m SimpleHTTPServer 8000
}

fin()  { grep --line-buffered "$@"; }  # Filter In
fout() { grep --line-buffered -v "$@"; }  # Filter Out

# Highlight matching regex in file or pipe
function hly {  # yellow
    GREP_COLORS="ne:mt=03;33" grep --line-buffered --color=always -Pi "($1|$)"
}
function hlb {  # blue
    GREP_COLORS="ne:mt=03;36" grep --line-buffered --color=always -Pi "($1|$)"
}
function hlg {  # green
    GREP_COLORS="ne:mt=03;32" grep --line-buffered --color=always -Pi "($1|$)"
}
function hlp {  # pink
    GREP_COLORS="ne:mt=03;35" grep --line-buffered --color=always -Pi "($1|$)"
}
alias hl=hly

# Versions of highlighters that work with k=v fields
FIELD_VALS="[\"[:alnum:]_\-:.]"
function hlf()  { hl  "$1=$FIELD_VALS+";}
function hlyf() { hly "$1=$FIELD_VALS+";}
function hlbf() { hlb "$1=$FIELD_VALS+";}
function hlgf() { hlg "$1=$FIELD_VALS+";}
function hlpf() { hlp "$1=$FIELD_VALS+";}

function _tmux_scrap {
    tmux send-keys 'cd ~/projects/scrap' C-m
    tmux send-keys 'make && ./scrap' C-m
    tmux split-window -h
    tmux send-keys 'cd ~/projects/scrap' C-m
    tmux send-keys 'v src/scrap.cpp' C-m
    tmux rename-window scrap
}
alias scrap=_tmux_scrap

# linemerge thing
function lm {
    delim=","
    [[ ! -z "$1" ]] && delim="$1"
    awk -v d="$delim" '{ s=(NR==1?s:s d)$0 } END {print s}'
}

function _tmsh {
    name="$1"
    if [[ -n "$name" ]]; then
        echo "no hostname"
    fi
    export TERM_TITLE="$name"
    reset && ssh -X -t $name "tmux attach -d -t $name || tmux new -s $name"
}
alias tmsh=_tmsh

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

# full release branch name
function gbname {
    tmp=$(grname)
    if [[ "$tmp" == "topic" ]]; then
        echo "master"
        return
    fi
    val=$(echo $tmp | cut -f1 -d/)
    echo "$val/current"
}

# rebase to tip of release
function grebase {
    base=$(gbname)
    if [[ $? -ne 0 ]]; then
        echo "error: no base" >&2
        return
    fi
    cur=$(gname)
    if [[ -z $cur ]]; then
        echo "error: no current branch" >&2
        return
    fi

    git checkout $base
    git up
    git checkout $cur
    git rebase $base
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

function gg {
    if [[ "$#" -eq 0 ]]; then
        echo "expect: commit message"
        return
    fi
    git commit -m "@goodgardening $1"
}

function perfrender {
    perf script -i $1 | stackcollapse-perf.pl --all | flamegraph.pl > $1.svg && sudo mv $1.svg /usr/share/nginx/html/
}
