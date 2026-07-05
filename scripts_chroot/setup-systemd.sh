cd /pkgs
cd systemd-*

export CFLAGS="$CFLAGS -Wno-error"
export CXXFLAGS="$CXXFLAGS -Wno-error"

meson setup build \
    --prefix=/usr \
    --libdir=lib \
    -Dwerror=false \
    -Dukify=false \
    -Dbootloader=false \
    -Defi=false \
    --buildtype=release 

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig