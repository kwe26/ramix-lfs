#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo " Ramix - GCC Pass 2"
echo "========================================"

: "${LFS:?}"
: "${LFS_TGT:?}"

cd /pkgs

GCC_SRC="$(find . -maxdepth 1 -type d -name 'gcc-*' | head -n1)"

if [ -z "$GCC_SRC" ]; then
    echo "ERROR: GCC source not found."
    exit 1
fi

cd "$GCC_SRC"

rm -rf build
mkdir build
cd build

echo
echo "Configuring GCC..."
echo

../configure \
    --build="$(../config.guess)" \
    --prefix=/usr \
    --enable-default-pie \
    --enable-default-ssp \
    --disable-fixincludes \
    --disable-nls \
    --disable-multilib \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libvtv \
    --enable-languages=c,c++

echo
echo "Building..."
echo

make -j"$(nproc)"

echo
echo "Installing..."
echo

make install

echo
echo "Refreshing linker cache..."
echo

ldconfig

echo
echo "Cleaning up..."
echo

rm -f /pkgs/setup-gcc-pass2.sh

echo
echo "========================================"
echo " GCC Pass 2 Completed Successfully"
echo "========================================"

gcc --version