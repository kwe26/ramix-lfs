cd /pkgs
PKG="$(find /pkgs -maxdepth 1 -type d \( -name 'RHash-*' -o -name 'rhash-*' \) | head -n1)"
cd $PKG

./configure \
    --prefix=/usr \
    --disable-static

make -j"$(nproc)"

make install PREFIX=/usr

install -Dm644 librhash/rhash.h /usr/include/rhash.h
install -Dm644 librhash/rhash_torrent.h /usr/include/rhash_torrent.h

ldconfig

install -Dm644 librhash/rhash.h \
    /usr/include/rhash.h

install -Dm644 librhash/rhash_torrent.h \
    /usr/include/rhash_torrent.h

mkdir -p /usr/lib/pkgconfig

install -Dm644 dist/librhash.pc \
    /usr/lib/pkgconfig/librhash.pc

    pkgconf --cflags librhash
pkgconf --libs librhash

ln -sf /usr/lib/librhash.so.1 /usr/lib/librhash.so

make install install-lib-so-link

ldconfig

cd /pkgs
cd cmake-*


./bootstrap \
    --prefix=/usr \
    --parallel="$(nproc)" \
    --system-libs \
    --no-system-cppdap \

make -j"$(nproc)"

make install

ldconfig

cmake --version