# Vagrant machines for Avatar / S2E

This git repository contains vagrant machines to quickly setup avatar
and S2E environments.

## Contents
There are currenlty two supported systems:
- Avatar: the oringal avatar, using epfl version of S2E, currently the
  recommended option
- newS2E: a work in progress port of S2E to a newer qemu version (See
 [this repository](https://github.com/eurecom-s3/news2e) for more
 information).

## Quickstart
Cd to the folder of your choice (Avatar or newS2E) and start the
virtual machine with `vagrant --provider virtualbox up`, connect to it
via `vagrant ssh -- -A` (-A is for agent forwarding, so that you can
directly commit to Github using your SSH key), and run the tests via
`cd projects/news2e/tests; make check`.

If you want to commit to Github, make sure to replace the repository URL of
the project with `git remote set-url origin git@github.com:eurecom-s3/project` where project is the project you want
to commit to (Use `git remote -v` to see the current remote).
