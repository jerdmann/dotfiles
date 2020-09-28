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

terse=""
if [[ "$1" == "--terse" ]]; then
    terse="yes"
    shift 1
fi

# build the mks list based on a union of what mks the user cares about and which ones are actually
# present in the tree
my_mks=$(for f in $(cat ~/.my_mks); do [[ -f "$rr/$f" ]] && printf "%s " $f; done)

# baseline params, plus gcc8 if present
params="use_distcc=0 -C $rr -j$(nproc --ignore 1) def_files=\"$my_mks\""
gcc8_mkvars="$rr/mds/all_mds_gcc8.mkvars"
[[ -f "$gcc8_mkvars" ]] && params="$params var_file_name=$gcc8_mkvars"

# terse mode if present
cmd="make $params $@"
[[ -z "$terse" ]] || cmd="$cmd | grep --line-buffered --color=never error:"

# execute the command and pass through its return code
eval $cmd
rc=$?
exit $rc
