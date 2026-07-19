#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install libinput"

VERSION="1.29.2"

[ -f "$LFS/tmp/libinput.tar.xz" ] || \
wget https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.30.4/libinput-1.30.4.tar.gz \
    -O "$LFS/tmp/libinput.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/libinput.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/libinput.sh"