cd /pkgs
cd e2fsprogs-*

mkdir -v build
cd build

if [ ! -e "/usr/bin/pkg-config" ] && [ -e "/usr/bin/pkgconf" ]; then
    ln -sf /usr/bin/pkgconf "/usr/bin/pkg-config"
fi
../configure \
    --prefix=/usr \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --libdir=/usr/lib \
    --disable-libblkid \
    --disable-libuuid \
    --disable-uuidd \
    --disable-fsck

make -j"$(nproc)"

make install

ldconfig