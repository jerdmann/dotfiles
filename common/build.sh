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

my_mks=$(for f in $(cat ~/.my_mks); do [[ -f "$rr/$f" ]] && printf "%s " $f; done)
if [[ -z "$terse" ]]; then
    make -C $rr -j$(nproc) use_distcc=0 def_files="$my_mks" $@ 2>&1
else
    make -C $rr -j$(nproc) use_distcc=0 def_files="$my_mks" $@ 2>&1 | grep --line-buffered --color=never error:
fi
rc=$?
exit $rc

