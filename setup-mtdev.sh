#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install mtdev"

VERSION="1.1.7"

[ -f "$LFS/tmp/mtdev.tar.bz2" ] || \
wget https://bitmath.org/code/mtdev/mtdev-${VERSION}.tar.bz2 \
    -O "$LFS/tmp/mtdev.tar.bz2"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/mtdev.tar.bz2"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/mtdev.sh"