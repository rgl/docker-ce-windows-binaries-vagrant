#!/bin/bash
set -eux


echo 'Defaults env_keep += "DEBIAN_FRONTEND"' >/etc/sudoers.d/env_keep_apt
chmod 440 /etc/sudoers.d/env_keep_apt
export DEBIAN_FRONTEND=noninteractive


#
# make sure the package index cache is up-to-date before installing anything.

apt-get update


# enable systemd-journald persistent logs.
sed -i -E 's,^#?(Storage=).*,\1persistent,' /etc/systemd/journald.conf
systemctl restart systemd-journald


#
# install vim.

apt-get install -y --no-install-recommends vim

cat >~/.vimrc <<'EOF'
syntax on
set background=dark
set esckeys
set ruler
set laststatus=2
set nobackup
EOF


#
# configure the shell.

cat >~/.bash_history <<'EOF'
EOF

cat >~/.bashrc <<'EOF'
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

export EDITOR=vim
export PAGER=less

alias l='ls -lF --color'
alias ll='l -a'
alias h='history 25'
alias j='jobs -l'
EOF

cat >~/.inputrc <<'EOF'
"\e[A": history-search-backward
"\e[B": history-search-forward
"\eOD": backward-word
"\eOC": forward-word
set show-all-if-ambiguous on
set completion-ignore-case on
EOF


#
# install docker.
# see https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository
# NB we can also install a specific version from https://download.docker.com/linux/ubuntu/dists/

apt-get install -y gnupg
apt-get install -y apt-transport-https #ca-certificates #software-properties-common
wget -qO- https://download.docker.com/linux/ubuntu/gpg | apt-key add -
[ -z "$(apt-key fingerprint 0EBFCD88 | grep '9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88')" ] && echo 'failed to verify docker apt repo fingerprint' && exit 1
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >/etc/apt/sources.list.d/docker.list
apt-get update
apt-cache madison docker-ce
docker_version='26.1.1'
docker_version="$(apt-cache madison docker-ce | awk "/$docker_version/{print \$3}")"
apt-get install -y "docker-ce=$docker_version" "docker-ce-cli=$docker_version" containerd.io
docker version


#
# configure git.

git config --global user.name 'Rui Lopes'
git config --global user.email 'rgl@ruilopes.com'
git config --global push.default simple
git config --global core.autocrlf false


#
# install build dependencies.

apt-get install -y make zip


#
# clone docker-ce and build the static windows binaries.

function clone-repo {
    local url=$1; shift;
    local directory=$1; shift;
    local revision=$1; shift;
    git clone $url $directory
    pushd $directory
    git reset --hard $revision
    popd
}

export VERSION='26.1.1'
export GIT_REF="v$VERSION"

# build docker daemon.
clone-repo https://github.com/moby/moby.git moby $GIT_REF
cd moby
time docker buildx bake all --set *.platform=windows/amd64
find bundles/binary/ -type f -exec ls -laF {} \;
cd ..

# build docker cli.
clone-repo https://github.com/docker/cli.git cli $GIT_REF
cd cli
echo "$VERSION" >VERSION
time docker buildx bake --set binary.platform=windows/amd64
find build/ -type f -exec ls -laF {} \;
cd ..

#
# package.

mkdir docker
cd docker
cp ../moby/bundles/binary/*.exe .
cp ../cli/build/docker-windows-amd64.exe docker.exe
cd ..
zip -9 -r docker-$VERSION.zip docker
sha256sum *.zip
if [ -d /vagrant ]; then
    cp *.zip /vagrant
fi
