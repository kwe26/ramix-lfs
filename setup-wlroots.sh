#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install wlroots"

VERSION="0.19.0"

[ -f "$LFS/tmp/wlroots.tar.gz" ] || \
wget https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/${VERSION}/wlroots-${VERSION}.tar.gz \
    -O "$LFS/tmp/wlroots.tar.gz"

cd "$LFS/pkgs"


tar -xf "$LFS/tmp/wlroots.tar.gz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/wlroots.sh"