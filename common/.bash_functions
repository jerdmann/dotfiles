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

alias fuck='$EDITOR $(git diff --name-only | uniq)'

function servethis {
    google-chrome http://localhost:8000 &
    python -m SimpleHTTPServer 8000
}

function tohex {
    perl -e "printf (\"%x\\n\", $1)"
}

