#!/usr/bin/env bash

set -euo pipefail
[ -n "$LFS" ] || {
    echo "ERROR: LFS is not set"
    exit 1
}

echo "=================================== Compiling Linux Kernel ============================="

KERNEL_SRC=$(echo "$LFS"/pkgs/linux-*)
cp linux.config "$KERNEL_SRC/.config"
cd "$KERNEL_SRC"

echo "=========================== Starting... ========================================="
make -j$(nproc)
echo "============================ Compiling Kernel Modules ============================== "
make modules_install INSTALL_MOD_PATH="$LFS/build"

echo "================================ Copying Boot Files ======================================"
mkdir -p $LFS/boot
cp $LFS/pkgs/linux-*/arch/x86/boot/bzImage $LFS/boot/bzImage
cp .config "$LFS/build/boot/config-$(make kernelrelease)"
cp System.map "$LFS/build/boot/System.map-$(make kernelrelease)"

echo "================== DONE! ======================"