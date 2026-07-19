#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd mtdev-*

./configure \
    --prefix=/usr

make -j"$(nproc)"

make install

ln -s /usr/lib/pkgconfig/mtdev.pc /usr/lib64/pkgconfig/mtdev.pc

ldconfig