# About

[![Build status](https://github.com/rgl/docker-ce-windows-binaries-vagrant/workflows/Build/badge.svg)](https://github.com/rgl/docker-ce-windows-binaries-vagrant/actions?query=workflow%3ABuild)

This is a [Vagrant](https://www.vagrantup.com/) Environment for building the static [moby (upstream of docker-ce)](https://github.com/moby/moby) Windows binaries.

This exists because recent builds are no longer available at https://download.docker.com/win/static/stable/x86_64/.

## Usage

Build and install the [Ubuntu Base Box](https://github.com/rgl/ubuntu-vagrant).

Run `vagrant up` to build the binaries and place the `.zip` at the current directory.
