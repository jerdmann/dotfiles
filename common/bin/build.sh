#!/bin/bash
# faster debesys builds.  to use:
# 1) populate ~/.my_mks with a list of mkfiles, one per line
#    for example:
#    some/project/build.mk
#    other/project/build.mk
# 2) run this script from anywhere in the repo like:
#    > ~/build.sh some_target other_target

rr=$(git rev-parse --show-toplevel)
if [[ "$rr" == "" ]]; then
    echo "error: no repo"
    exit -1
fi

# non-terse by default
terse=""
# no mks list by default
mks_file=""
# rebuild all_messages by default
proto=""
config="debug"
cache=""
ext=""
args=""
jobs=""
arg_mkvars=""

while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--terse" ]]; then
        terse="yes"
        shift 1
    elif [[ "$1" == "--mks-file" ]]; then
        mks_file="$2"
        shift 2
    elif [[ "$1" == "--no-proto" ]]; then
        proto="proto_files=\"\""
        shift 1
    elif [[ "$1" == "--idebug" ]]; then
        config="idebug"
        shift 1
    elif [[ "$1" == "--use-cache" ]]; then
        cache="use_cache=1"
        shift 1
    elif [[ "$1" == "--ext" ]]; then
        ext="yes"
        shift 1
    elif [[ "$1" == "-j" ]]; then
        jobs=$2
        shift 2
    elif [[ "$1" == "--mkvars" ]]; then
        arg_mkvars=$2
        shift 2
    else 
        if [[ -z "$args" ]]; then
            args="$1"
        else
            args="$args $1"
        fi
        shift 1
    fi
done

if [[ -z "$args" ]]; then
    echo "error: no target(s)"
    exit -1
fi

# baseline params, plus gcc9 if present
if [[ -z "$jobs" ]]; then
    if [[ -z "$GCC_CPU_CORES" ]]; then
        jobs=$(nproc --ignore 4)
    else
        jobs=$GCC_CPU_CORES
    fi
fi
params="config=$config use_distcc=0 $cache -C $rr -j$jobs $args"

gcc9_mkvars="$rr/base_gcc9_cxx11.mkvars"
if [[ ! -z "$arg_mkvars" && -r "$arg_mkvars" ]]; then
    params="$params var_file_name=$arg_mkvars"
elif [[ -r "$gcc9_mkvars" && -z "$ext" ]]; then
    params="$params var_file_name=$gcc9_mkvars"
else
    params="$params var_file_name=base.mkvars"
fi

if [[ "$proto" != "" ]]; then
    params="$params $proto"
fi

# build the mks list based on a union of what mks the user cares about and which
# ones are actually present in the tree
if [[ "$mks_file" != "" ]]; then
    my_mks=$(for f in $(cat "$rr/$mks_file"); do [[ -f "$rr/$f" ]] && printf "%s " $f; done)
    echo $my_mks
    params="$params def_files=\"$my_mks\""

    # no-op processing the all_messages mkfiles means invoking protoc once for every proto file
    # this is rather expensive.  skip it if we're running a streamlined build
    export SKIP_PROTO_RULES=1
fi

# terse mode if present
cmd="make $params $@"
if [[ "$terse" == "yes" ]]; then
    cmd="$cmd 2>&1 | grep --line-buffered -v -e 'given more than once' -e note: -e discover_mkvars -e PATH="
fi

# execute the command and pass through its return code
eval $cmd
rc=$?
# rc="${PIPESTATUS[0]}"
exit $rc
