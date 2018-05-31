#!/bin/bash
rr=$(git rev-parse --show-toplevel)
if [[ "$rr" == "" ]]; then
    echo "error: no repo"
    exit -1
fi

if [[ "$#" -eq 0 ]]; then
    echo "error: no target(s)"
    exit -1
fi

make -j$(nproc) use_distcc=0 def_files="$(awk '{printf "%s ", $1}' ~/.my_mks)" -C $rr $@ 2>&1
