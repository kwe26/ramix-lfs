#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd wlroots-*

sed -i "s/char \*colon = strchr(path, ':');/const char *colon = strchr(path, ':');/" xcursor/xcursor.c

rm -rf build

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Dxwayland=disabled \
    -Dxcb-errors=disabled \
    -Dexamples=true \
    -Drenderers=gles2 \
    -Dbackends=drm,libinput \
    -Dsession=enabled

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig

install -Dm755 \
    ./build/tinywl/tinywl \
    /usr/bin/tinywl