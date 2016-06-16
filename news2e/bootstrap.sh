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

cat - <<EOF > ~/.tmux.conf
# tmux-screen-keys.conf
#
# By Nicholas Marriott. Public domain.
# Updated by Dustin Kirkland.
#
# This configuration file binds many of the common GNU screen key bindings to
# appropriate tmux key bindings. Note that for some key bindings there is no
# tmux analogue and also that this set omits binding some commands available in
# tmux but not in screen.
#
# Note this is only a selection of key bindings and they are in addition to the
# normal tmux key bindings. This is intended as an example not as to be used
# as-is.

# Set the prefix to ^A.
unbind C-b
set -g prefix ^A
bind a send-prefix

# Bind appropriate commands similar to screen.
# lockscreen ^X x
unbind ^X
bind ^X lock-server
unbind x
bind x lock-server

# screen ^C c
unbind ^C
bind ^C new-window -c "#{pane_current_path}"
unbind c
bind c new-window -c "#{pane_current_path}"

# detach ^D d
unbind ^D
bind ^D detach

# displays *
unbind *
bind * list-clients

# next ^@ ^N sp n
unbind ^@
bind ^@ next-window
unbind ^N
bind ^N next-window
unbind " "
bind " " next-window
unbind n
bind n next-window

# title A
unbind A
bind A command-prompt "rename-window %%"

# other ^A
unbind ^A
bind ^A last-window

# prev ^H ^P p ^?
unbind ^H
bind ^H previous-window
unbind ^P
bind ^P previous-window
unbind p
bind p previous-window
unbind BSpace
bind BSpace previous-window

# windows ^W w
unbind ^W
bind ^W list-windows
unbind w
bind w list-windows

# quit \
unbind '\'
bind '\' confirm-before "kill-server"

# kill K k
unbind K
bind K confirm-before "kill-window"
unbind k
bind k confirm-before "kill-window"

# redisplay ^L l
unbind ^L
bind ^L refresh-client
unbind l
bind l refresh-client

# split -v |
unbind |
bind | split-window -c "#{pane_current_path}"

# :kB: focus up
unbind Tab
bind Tab select-pane -t:.+
unbind BTab
bind BTab select-pane -t:.-

# " windowlist -b
unbind '"'
bind '"' choose-window

# Enable mouse
set -g mode-mouse on
set -g mouse-resize-pane on
set -g mouse-select-pane on
set -g mouse-select-window on
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



