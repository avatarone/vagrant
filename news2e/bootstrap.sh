#!/bin/sh

sudo add-apt-repository -y ppa:team-gcc-arm-embedded/ppa
sudo apt-get update
sudo apt-get install -y git clang binutils-dev vim \
    libiberty-dev zlib1g-dev libgettextpo-dev \
    flex bison pkg-config libglib2.0-dev liblua5.1-0-dev \
    libpixman-1-dev libfdt-dev gcc-arm-embedded \
    ruby-aruba cucumber ctags libc6-dev-i386 gdb

cat - <<EOF > .gitconfig
[alias]
    lol = log --graph --decorate --pretty=oneline --abbrev-commit
    lola = log --graph --decorate --pretty=oneline --abbrev-commit --all

[core]
    editor = vim

[push]
    default = simple

[pull]
    rebase = true
EOF

mkdir projects
cd projects
git clone https://github.com/eurecom-s3/news2e
mkdir news2e-build
( cd news2e-build && make -f ../news2e/Makefile )



