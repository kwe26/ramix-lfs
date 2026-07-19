#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install seatd"

VERSION="0.9.1"

[ -f "$LFS/tmp/seatd.tar.gz" ] || \
wget https://git.sr.ht/~kennylevinsen/seatd/archive/${VERSION}.tar.gz \
    -O "$LFS/tmp/seatd.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/seatd.tar.gz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/seatd.sh"