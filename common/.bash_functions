# vim: set ft=bashrc
function cbup {
    knife cookbook --cookbook-path `git rev-parse --show-toplevel`/deploy/chef/cookbooks upload "$@"
}

function rr {
    reporootdir=$(git rev-parse --show-toplevel)
    [[ -n "$reporootdir" ]] || return
    basedir=$(basename $reporootdir)
    if [[ $basedir == "ext" || $basedir == "the_arsenal" ]]; then
        reporootdir=$(dirname $reporootdir)
    fi
    pushd $reporootdir >/dev/null
}

export _wk_container_name=trusty_manticore
    
function dwork {
    docker start $_wk_container_name 2>/dev/null
    docker attach $_wk_container_name
}

function dworkbuild {
    docker run -it --network=host --name=$_wk_container_name \
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

fin()  { grep --line-buffered --color=always "$@"; }  # Filter In
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
    tmux split-window -h
    tmux send-keys 'cd ~/projects/scrap' C-m
    tmux select-pane -L
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
