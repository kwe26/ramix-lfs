cd /pkgs
cd glib-*

meson setup build \
    --prefix=/usr \
    --libdir=lib \
    --buildtype=release \
    -Ddefault_library=shared \
    -Dtests=false \
    -Dnls=enabled

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig

glib-compile-schemas --version