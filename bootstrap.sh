#!/bin/bash
packages=(
build-essential
ctags
g++-multilib
git
jq
lib32z1
libc6:i386
libgl1-mesa-glx-lts-trusty:i386
libncurses5-dev
libpcre3-dev
libreadline-dev
libssl-dev
linux-tools-4.4.0-72-generic
linux-tools-generic
make
openjdk-7-jre
perl
python3
silversearcher-ag
stow
tmux
valgrind
vim-gtk
xclip
zsh
)

sudo apt-get -y install "${packages[@]}"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
