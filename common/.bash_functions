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

function external-knife_() {
    knife "$@" -c ~/.chef/knife.external.rb
}
alias eknife='external-knife_'

alias ksj='knife search "tags:jerdmann*"'
alias ke='knife node edit'
alias ksh='knife node show'
alias eke='eknife node edit'
alias eksh='eknife node show'
alias fuck='$EDITOR $(git diff --name-only | uniq)'

function ks {
    rl="$1"
    env="$2"
    shift 2

    args="$@"
    if [[ -z "$args" ]]; then
        args="-a chef_environment -a ipaddress -a run_list -a tags"
    fi
    knife search "run_list:*$rl* AND chef_environment:*$env* NOT chef_environment:*-delayed" ${=args}
}

function ksn {
    rl="$1"
    env="$2"

    knife search "run_list:*$rl* AND chef_environment:*$env* NOT chef_environment:*-delayed" -a name | grep "name:" | awk '{printf "%s ", $2}'
}


function eks {
    rl="$1"
    env="$2"
    shift 2

    args="$@"
    if [[ -z "$args" ]]; then
        args="-a chef_environment -a ipaddress -a run_list -a tags"
    fi
    eknife search "run_list:*$rl* AND chef_environment:*$env* NOT chef_environment:*-delayed" ${=args}
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
price_server/pds_uploader
price_server/ps_common
price_server/exchange/cme
price_server/exchange/eurex_lh
price_server/exchange/euronext_lh/optiq
price_server/exchange/gdax_lh
price_server/exchange/lme_lh
price_server/exchange/tmx_lh
price_server/price_client
price_server/price_unifier
test
price_server/test
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
