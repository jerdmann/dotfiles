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

if [[ "$#" -eq 0 ]]; then
    echo "error: no target(s)"
    exit -1
fi

# non-terse by default
terse=""
# no mks list by default
mks_file=""
# rebuild all_messages by default
proto=""
config="debug"

while true; do
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
    else 
        break
    fi
done

# baseline params, plus gcc8 if present
params="config=$config use_distcc=0 -C $rr -j$(nproc --ignore 2)"

has_gcc8=""
$(gcc --version | grep -P '8\.\d+\.\d+' >/dev/null)
if [[ $? -eq 0 ]]; then 
    has_gcc8="yes"
fi
gcc8_mkvars="$rr/mds/all_mds_gcc8.mkvars"

if [[ "$has_gcc8" == "yes" && "$gcc8_mkvars" != "" ]]; then
    params="$params var_file_name=$gcc8_mkvars"
fi

if [[ "$proto" != "" ]]; then
    params="$params $proto"
fi

# build the mks list based on a union of what mks the user cares about and which ones are actually
# present in the tree
if [[ "$mks_file" != "" ]]; then
    my_mks=$(for f in $(cat "$mks_file"); do [[ -f "$rr/$f" ]] && printf "%s " $f; done)
    params="$params def_files=\"$my_mks\""
fi

# terse mode if present
cmd="make $params $@ 2>&1"
if [[ "$terse" == "yes" ]]; then
    cmd="$cmd | grep --line-buffered -v 'given more than once' | grep --line-buffered --color=never error:"
fi

# execute the command and pass through its return code
eval $cmd
rc=$?
exit $rc
