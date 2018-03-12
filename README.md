This is a [Vagrant](https://www.vagrantup.com/) Environment for building the static docker-ce Windows binaries.

This exists because recent builds are no longer available at https://download.docker.com/win/static/stable/x86_64/.

# Usage

Build and install the [Ubuntu Base Box](https://github.com/rgl/ubuntu-vagrant).

Run `vagrant up` to build docker-ce and place the `.zip` at the current directory.
