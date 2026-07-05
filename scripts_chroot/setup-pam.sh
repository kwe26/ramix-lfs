cd /pkgs
cd Linux-PAM-*

meson setup build \
    --prefix=/usr \
    --libdir=lib \
    --buildtype=release \
    -Ddefault_library=shared \
    -Ddocs=disabled \
    -Dnis=disabled

meson compile -C build -j"$(nproc)"

meson install -C build

mkdir -p /etc/pam.d

ldconfig
