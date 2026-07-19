#!/usr/bin/env bash
set -e

echo "Download & Install Git"

GIT_VERSION="2.53.0"

[ -f "$LFS/tmp/git.tar.xz" ] || \
wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.xz \
    -O "$LFS/tmp/git.tar.xz"

cd "$LFS/pkgs"

rm -rf git-*

tar -xf "$LFS/tmp/git.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/git.sh"