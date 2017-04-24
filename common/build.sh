#!/bin/bash
repo=$1
shift
make -j$(nproc) def_search_path="price_server the_arsenal/all_messages" -C /home/jason/dev-root/debesys-$repo "$@" 2>&1 | grep -v -e python.mk -e "setting " -e "commands for target"
