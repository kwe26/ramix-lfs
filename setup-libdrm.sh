#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install libdrm"

VERSION="2.4.125"

[ -f "$LFS/tmp/libdrm.tar.xz" ] || \
wget https://dri.freedesktop.org/libdrm/libdrm-${VERSION}.tar.xz \
    -O "$LFS/tmp/libdrm.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/libdrm.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/libdrm.sh"