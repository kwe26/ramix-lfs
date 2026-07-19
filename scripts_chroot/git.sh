#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd git-*

./configure \
    --prefix=/usr \
    --with-openssl \
    --with-curl \
    --with-expat

make -j"$(nproc)"

make install

ldconfig