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

export _wk_container_name=rusty_manticore
    
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
