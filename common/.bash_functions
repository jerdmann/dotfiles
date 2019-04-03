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

function external_knife_() {
    knife "$@" -c ~/.chef/knife.external.rb
}
alias eknife='external_knife_'

alias ksj='knife search "tags:jerdmann*"'
alias ke='knife node edit'
alias ksh='knife node show'
alias eke='eknife node edit'
alias eksh='eknife node show'
alias fuck='$EDITOR $(git diff --name-only | uniq)'

filter_genpop="NOT chef_environment:*-delayed NOT run_list:*ps_server\:\:loopback* NOT run_list:*depth_coll*"

# has to be a better way to do this.  hilarious noop filter for now
filter_none="NOT chef_environment:*fffffff*"

# various "nice" front-ends
function ks {
    _knife_search knife "$filter_genpop" "$@"
}

function eks {
    _knife_search external_knife_ "$filter_genpop" "$@"
}

function kps {
    _knife_search knife "$filter_genpop" "$@"
}

function ekps {
    _knife_search external_knife_ "$filter_genpop" "$@"
}

function ksn {
    _knife_flat_search knife "$1" "$2"
}

function eksn {
    _knife_flat_search external_knife_ "$1" "$2"
}

function kpdsu {
    _knife_search knife "$filter_none" "pds_uploader_$1" "$2"
}

function ekpdsu {
    _knife_search external_knife_ "$filter_none" "pds_uploader_$1" "$2"
}

# single entrypoint for knife searches
function _knife_search {
    cmd="$1"
    filter="$2"
    rl="$3"
    env="$4"
    shift 4
    args="$@"

    if [[ -z "$args" ]]; then
        args="-a chef_environment -a ipaddress -a run_list -a tags"
    fi
    $cmd search "run_list:*$rl* AND chef_environment:*$env* $filter" ${=args}
}

# similar, but one-line server names output
# handy for populating CLI args to other tools
function _knife_flat_search {
    cmd="$1"
    rl="$2"
    env="$3"

    $cmd search "run_list:*$rl* AND chef_environment:*$env*" -a name | grep "name:" | awk '{printf "%s ", $2}'
}

function kssh {
    knife ssh -a ipaddress "run_list:*$1* AND chef_environment:*$2*" "$3"
}

function bgf {
    knife tag create $1 basegofast
}

function pmake {
    ~/build.sh $@
}

function lmake {
    rr || return
    make -j$(nproc) use_distcc=0 $@
    popd >/dev/null
}

function isearch {
    rr || return
    ./run python price_server/tests/pds_test/tools/instrument_search.py $@
    popd >/dev/null
}

export MY_PRICE_TARGETS="price_server test_lh price_client_test price_unifier_test price_decoder"
function ptmake {
    rr || return
    ~/build.sh $MY_PRICE_TARGETS
    popd >/dev/null
}

function sbe {
    rr || return
    sbe_dir=price_server/ps_common/sbe_messages
    cd $sbe_dir
    SBE_JAR=$reporootdir/$sbe_dir/sbe-all.jar
    ./make_schema.sh
    cd sbe_common
    $reporootdir/run python make_enums.py
    popd >/dev/null
}

function lbmify {
    rr
    mkdir -p build/x86-64/debug/etc/debesys
    mkdir -p build/x86-64/idebug/etc/debesys
    mkdir -p build/x86-64/release/etc/debesys
    mkdir -p build/x86-64/irelease/etc/debesys
    cp ~/lbm_license_file.txt build/x86-64/debug/etc/debesys/
    cp ~/lbm_license_file.txt build/x86-64/idebug/etc/debesys/
    cp ~/lbm_license_file.txt build/x86-64/release/etc/debesys/
    cp ~/lbm_license_file.txt build/x86-64/irelease/etc/debesys/
}

function servethis {
    google-chrome http://localhost:8000 &
    python -m SimpleHTTPServer 8000
}

function tohex {
    perl -e "printf (\"%x\\n\", $1)"
}

project_dirs=(
lbm
misc/miscutils
price_server/ps_common
price_server/exchange_adapter
price_server/price_client
price_server/price_unifier
test
price_server/test
the_arsenal/all_messages/source/tt/messaging
)

function tag {
    rr || return
    cat /dev/null > tags
    for d in $(echo "${project_dirs[@]}" | tr -s " " | tr " " "\n")
    do {
        ctags -Ra $d
    }; done
    popd >/dev/null
}

function perf-crunch {
    sudo chmod 644 perf.data && perf script > out.perf && stackcollapse-perf.pl out.perf > out.folded && sudo flamegraph.pl out.folded > perf.svg
}

function mkdeb () {
    sudo mkdir /etc/debesys 2>/dev/null || :
    sudo mkdir /var/log/debesys 2>/dev/null || :
    sudo chown jason /etc/debesys
    sudo chown jason /var/log/debesys
    sudo chmod 775 /etc/debesys
    sudo chmod 775 /var/log/debesys
}

function testify () {
    reporootdir=$(git rev-parse --show-toplevel)
    [[ -n "$reporootdir" ]] || return
    rm -rf build/x86-64/debug/python/tt/price_server
    ln -sf $reporootdir/price_server/test/tt/price_server build/x86-64/debug/python/tt
}
