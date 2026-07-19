#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install libxkbcommon"

VERSION="1.12.2"

[ -f "$LFS/tmp/libxkbcommon.tar.gz" ] || \
wget https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.12.4.tar.gz \
    -O "$LFS/tmp/libxkbcommon.tar.gz"

cd "$LFS/pkgs"


tar -xf "$LFS/tmp/libxkbcommon.tar.gz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/libxkbcommon.sh"