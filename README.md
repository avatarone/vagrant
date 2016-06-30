# Vagrant machines for Avatar / S2E

This git repository contains Vagrant machines to quickly setup Avatar
and S2E environments.

## Contents
There are currenlty two supported systems:
- avatar: the original Avatar, using EPFL version of S2E, currently the
  recommended option
- news2e: a work in progress port of S2E to a newer QEMU version (See
 [this repository](https://github.com/eurecom-s3/news2e) for more
 information).

## Quickstart
CD to the folder of your choice (avatar or news2e) and start the
virtual machine with `vagrant up --provider=virtualbox`, connect to it
via `vagrant ssh -- -A` (-A is for agent forwarding, so that you can
directly commit to Github using your SSH key).

# Notes
For news2e configutation you can run the tests via `cd
projects/news2e/tests; make check`.

If you want to commit to Github, make sure to replace the repository URL of
the project with `git remote set-url origin git@github.com:eurecom-s3/project`
where project is the project you want to commit to (Use `git remote -v` 
to see the current remote).
