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

make -j$(nproc) def_search_path="misc fixit price_server the_arsenal" -C $rr $@ 2>&1 | grep -v -e python.mk -e "setting " -e "commands for target"
