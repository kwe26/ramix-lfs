#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install Pixman"

VERSION="0.46.4"

[ -f "$LFS/tmp/pixman.tar.gz" ] || \
wget https://cairographics.org/releases/pixman-${VERSION}.tar.gz \
    -O "$LFS/tmp/pixman.tar.gz"

cd "$LFS/pkgs"

rm -rf pixman-*

tar -xf "$LFS/tmp/pixman.tar.gz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/pixman.sh"