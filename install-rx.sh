#!/usr/bin/env bash
set -Eeuo pipefail

LFS=$(pwd)

RXOUTS="$LFS/rxouts"
PKGDIR="$LFS/pkgs/.rx"

mkdir -p "$PKGDIR"

echo " Copying RX Packages"
echo

find "$RXOUTS" \
    -mindepth 2 \
    -maxdepth 2 \
    -name "*.rx" \
    -exec cp -fv {} "$PKGDIR/" \;

echo
echo " Installing Packages"
echo

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/rxinstall.sh"