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

export WIRESHARK_DIR='/usr/lib/x86_64-linux-gnu/wireshark/plugins/1.12.1'
alias cdws='cd $WIRESHARK_DIR'

function wsenable {
    if [[ -z "$1" ]]; then
        printf "arg needed\n"
        return
    fi
    pushd $WIRESHARK_DIR
    rm enabled.lua 2>/dev/null || :

    plugins=$(ls *$1*.lua* 2>/dev/null)
    if [[ -z "$plugins" ]]; then
        printf "no matches\n"
        popd
        return
    fi

    plugin=$(echo $plugins | head -n1)
    printf "enabling %s\n" $plugin
    ln -sf $plugin enabled.lua
    popd
}
    
function wsdisable {
    pushd $WIRESHARK_DIR
    rm enabled.lua || :
    popd
}

fin()  { grep --line-buffered -Pi "$1"; }  # Filter In
fout() { grep --line-buffered -v -Pi "$1"; }  # Filter Out

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
