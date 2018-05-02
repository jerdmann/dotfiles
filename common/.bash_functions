# vim: set ft=bashrc
function cbup {
    knife cookbook --cookbook-path `git rev-parse --show-toplevel`/deploy/chef/cookbooks upload "$@"
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
alias fuck='vim $(git diff --name-only | uniq)'

function ks {
    rl="$1"
    env="$2"
    shift 2

    args="$@"
    if [[ -z "$args" ]]; then
        args="-a chef_environment -a ipaddress -a run_list -a tags"
    fi
    knife search "run_list:*$rl* AND chef_environment:*$env*" $args
}

function eks {
    rl="$1"
    env="$2"
    shift 2

    args="$@"
    if [[ -z "$args" ]]; then
        args="-a chef_environment -a ipaddress -a run_list -a tags"
    fi
    eknife search "run_list:*$rl* AND chef_environment:*$env*" $args
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
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        make -j16 use_distcc=0 $@
        popd
    fi
}

function dmake {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        make -j32 def_files="$(awk '{printf "%s ", $1}' ~/.my_mks)" $@
        popd
    fi
}

function isearch {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        ./run python price_server/tests/pds_test/tools/instrument_search.py $@
        popd
    fi
}

export MY_PRICE_TARGETS="price_server test_lh gdax_lh price_client_test price_decoder"
function ptmake {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        make -j$(nproc) def_files="$(awk '{printf "%s ", $1}' ~/.my_mks)" use_distcc=0 $MY_PRICE_TARGETS
        popd
    fi
}

function dptmake {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        make -j32 price_server $MY_PRICE_TARGETS
        popd
    fi
}

function sbe {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir/price_server/ps_common/sbe_messages
        SBE_JAR=$reporootdir/price_server/ps_common/sbe_messages/sbe-all.jar
        ./make_schema.sh
        cd sbe_common
        $reporootdir/run python make_enums.py
        popd
    fi
}

function makehome {
    scp ~/.vimrc "$1":~ && scp -r ~/.vim "$1":~ &>/dev/null && scp ~/.tmux.conf "$1":~
}

function rr {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        cd $reporootdir
        basedir=$(basename $PWD)
        if [[ $basedir == "ext" || $basedir == "the_arsenal" ]]; then
            cd ..
        fi
    fi
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

export PROJECT_DIRS="lbm price_server/pds_uploader price_server/ps_common price_server/exchange/gdax_lh price_server/price_client price_server/price_unifier test price_server/test"
function tag {
    reporootdir=$(git rev-parse --show-toplevel)
    if [[ $? -eq 0 ]]; then
        pushd $reporootdir
        cat /dev/null > tags
        for d in $(echo $PROJECT_DIRS | tr -s " " | tr " " "\n")
        do {
            ctags -a $d
        }; done
        popd
    fi
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

