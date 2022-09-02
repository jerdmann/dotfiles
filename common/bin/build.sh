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
if [[ -z "$GCC_CPU_CORES" ]]; then
    jobs=$(nproc --ignore 2)
else
    jobs=$GCC_CPU_CORES
fi
params="config=$config use_distcc=0 $cache -C $rr -j$jobs $args"

gcc9_mkvars="$rr/base_gcc9_cxx11.mkvars"
if [[ -r "$gcc9_mkvars" && -z "$ext" ]]; then
    params="$params var_file_name=$gcc9_mkvars"
fi

if [[ "$proto" != "" ]]; then
    params="$params $proto"
fi

# build the mks list based on a union of what mks the user cares about and which
# ones are actually present in the tree
if [[ "$mks_file" != "" ]]; then
    my_mks=$(for f in $(cat "$mks_file"); do [[ -f "$rr/$f" ]] && printf "%s " $f; done)
    params="$params def_files=\"$my_mks\""
fi

# terse mode if present
cmd="make $params $@"
if [[ "$terse" == "yes" ]]; then
    cmd="$cmd 2>&1 | grep --line-buffered -v -e 'recipe for target' -e 'given more than once' -e 'Use of this header'"
fi

# execute the command and pass through its return code
eval $cmd
rc=$?
exit $rc
