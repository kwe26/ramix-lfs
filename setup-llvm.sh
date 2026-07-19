#!/usr/bin/env bash
set -Eeuo pipefail

echo "Download & Install LLVM"

VERSION="21.1.0"

[ -f "$LFS/tmp/llvm.tar.xz" ] || \
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION}/llvm-project-${VERSION}.src.tar.xz \
    -O "$LFS/tmp/llvm.tar.xz"

cd "$LFS/pkgs"


tar -xf "$LFS/tmp/llvm.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/llvm.sh"