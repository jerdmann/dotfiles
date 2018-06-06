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

#export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
my_mks=$(for f in $(cat ~/.my_mks); do [[ -f "$f" ]] && printf "%s " $f; done)
make -j$(nproc) use_distcc=0 def_files="$my_mks" -C $rr $@ 2>&1
