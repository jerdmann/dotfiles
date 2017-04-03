#!/bin/bash
sudo apt-get -y install openjdk-7-jre g++-multilib git vim-gtk stow zsh ctags silversearcher-ag nfs-common python3 docker.io icedtea-7-plugin lib32z1 libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential docker.io libc6:i386 libgl1-mesa-glx-lts-trusty:i386 valgrind tmux xclip jq

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
