cd /pkgs
cd dbus-*

meson setup build \
    --prefix=/usr \
    --libdir=lib \
    --buildtype=release \
    -Ddefault_library=shared \
    -Dsystemd=enabled 

meson compile -C build -j"$(nproc)"

meson install -C build

mkdir -p /var/lib/dbus

ldconfig

dbus-uuidgen --ensure

ldconfig

dbus-daemon --version