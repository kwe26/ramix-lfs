#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd mesa-*

rm -rf build

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Dplatforms=wayland \
    -Dgallium-drivers=llvmpipe,virgl \
    -Dvulkan-drivers=[] \
    -Dllvm=enabled \
    -Dglx=disabled \
    -Dshared-glapi=enabled \
    -Degl=enabled \
    -Dgbm=enabled \
    -Dcpp_rtti=false \
    -Dgles1=disabled \
    -Dgles2=enabled \
    -Dbuild-tests=false

meson configure build | grep -E "gallium-drivers|vulkan-drivers|egl|gbm|shared-glapi"

meson compile -C build -j"$(nproc)"
meson install -C build
ldconfig