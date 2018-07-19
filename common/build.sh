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

pushd $rr >/dev/null
my_mks=$(for f in $(cat ~/.my_mks); do [[ -f "$f" ]] && printf "%s " $f; done)
make -j$(nproc) use_distcc=0 def_files="$my_mks" $@ 2>&1
rc=$?
popd >/dev/null
exit $rc
