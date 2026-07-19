#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install libevdev"

VERSION="1.13.4"

[ -f "$LFS/tmp/libevdev.tar.xz" ] || \
wget https://www.freedesktop.org/software/libevdev/libevdev-${VERSION}.tar.xz \
    -O "$LFS/tmp/libevdev.tar.xz"

cd "$LFS/pkgs"


tar -xf "$LFS/tmp/libevdev.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/libevdev.sh"