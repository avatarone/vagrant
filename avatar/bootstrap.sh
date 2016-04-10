#!/bin/sh

add-apt-repository -y ppa:team-gcc-arm-embedded/ppa
apt-get update
apt-get install -y git subversion binutils-dev gettext flex bison pkg-config \
    libglib2.0-dev nasm liblua5.1-0-dev libsigc++-2.0-dev \
    texinfo gcc-arm-embedded expat libexpat1-dev python2.7-dev \
    
su - vagrant    
mkdir projects
(
    cd projects 
    git clone --branch eurecom/avatar https://github.com/eurecom-s3/s2e.git
    mkdir s2e-build
    (
        cd s2e-build
        make -f ../s2e/Makefile
    )
    git clone --branch eurecom/wip https://github.com/eurecom-s3/gdb.git 
    mkdir gdb-build
    (
        cd gdb-build
        ../gdb/configure --with-python --with-expat=yes --target=arm-none-eabi
        make -j4
    )
    git clone --branch master https://github.com/eurecom-s3/avatar-python
    git clone --branch master https://github.com/eurecom-s3/avatar-samples
    git clone --branch eurecom/wip https://github.com/eurecom-s3/openocd
)
