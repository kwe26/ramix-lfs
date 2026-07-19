#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install wayland-protocols"

VERSION="1.49"

[ -f "$LFS/tmp/wayland-protocols.tar.xz" ] || \
wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/${VERSION}/downloads/wayland-protocols-${VERSION}.tar.xz \
    -O "$LFS/tmp/wayland-protocols.tar.xz"

cd "$LFS/pkgs"


tar -xf "$LFS/tmp/wayland-protocols.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/wayland-protocols.sh"