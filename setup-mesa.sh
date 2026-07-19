#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install Mesa"

VERSION="26.1.5"

[ -f "$LFS/tmp/mesa.tar.xz" ] || \
wget https://archive.mesa3d.org/mesa-${VERSION}.tar.xz \
    -O "$LFS/tmp/mesa.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/mesa.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/mesa.sh"