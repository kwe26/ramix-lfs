#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install libdisplay-info"

VERSION="0.3.0"

wget https://github.com/vcrhonek/hwdata/archive/refs/tags/v0.396.tar.gz -O "$LFS/tmp/hwdata.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/hwdata.tar.gz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/hwdata.sh"

[ -f "$LFS/tmp/libdisplay-info.tar.xz" ] || \
wget https://gitlab.freedesktop.org/emersion/libdisplay-info/-/releases/${VERSION}/downloads/libdisplay-info-${VERSION}.tar.xz \
    -O "$LFS/tmp/libdisplay-info.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/libdisplay-info.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/libdisplay-info.sh"