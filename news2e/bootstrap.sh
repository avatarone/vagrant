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

cat - <<EOF > .vimrc
" Do syntax coloring and smart indentation 
syntax on
set smartindent

" per default put 4 spaces instead of tab 
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Make backspace work sanely
set backspace=indent,eol,start

" enable mouse scrolling and tab clicking
set mouse=a

" A better color scheme
:colorscheme desert

" Makefiles do not like tab expansion
:autocmd FileType make set noexpandtab

" enable history
set history=1000

" enable spell checking
" set spell
EOF

#shared
BASEDIR=/vagrant/
#local only
BASEDIR=/home/vagrant/

mkdir projects
cd projects

# Check out the source code
git clone https://github.com/eurecom-s3/news2e

# Build the source code
mkdir news2e-build
( cd news2e-build && make -f ../news2e/Makefile )

# There is a bug in compiler-rt which reports a missing features.h.
# Weirdly enough, it's simply enough to restart the build.
( cd news2e-build/llvm-native && make )
( cd news2e-build && make -f ../news2e/Makefile )

# The test repository does not check out through the build script
( cd news2e && git submodule update --init test )

# There is a bug which manifests only in the release build of qemu.
# Until we have fixed that, use the debug build.
( cd news2e-build && make -f ../news2e/Makefile stamps/qemu-debug-make )

# Add export for S2E_DIR to profile
echo "export S2E_DIR=$(pwd)/news2e-build/qemu-debug" >> $HOME/.profile



