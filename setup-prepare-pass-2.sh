#!/usr/bin/env bash
set -euo pipefail

export LFS=$(pwd)

: "${LFS:?Please export LFS first.}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo " Preparing Ramix Pass 2 Environment"
echo "========================================"

mkdir -p \
    "$LFS/build"/{dev,proc,sys,tmp,pkgs}

mount --rbind /dev "$LFS/build/dev"
mount --make-rslave "$LFS/build/dev"

mount -t proc proc "$LFS/build/proc"
mount -t sysfs sysfs "$LFS/build/sys"

mount -t tmpfs \
    -o mode=1777,size=4G \
    tmpfs "$LFS/build/tmp"

mount --bind "$LFS/pkgs" "$LFS/build/pkgs"

cp "$SCRIPT_DIR/setup-gcc-pass2.sh" \
   "$LFS/build/pkgs/setup-gcc-pass2.sh"

chmod +x "$LFS/build/pkgs/setup-gcc-pass2.sh"

echo
echo "Entering Chroot..."
echo

exec chroot "$LFS/build" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PATH=/usr/bin:/usr/sbin:/bin:/sbin \
    MAKEFLAGS="-j$(nproc)" \
    TESTSUITEFLAGS="-j$(nproc)" \
    LFS=/ \
    LFS_TGT="$(uname -m)-lfs-linux-gnu" \
    /pkgs/setup-gcc-pass2.sh