cd /pkgs
cd curl-*

./configure \
    --prefix=/usr \
    --disable-static \
    --with-openssl \
    --with-zlib \
    --without-libpsl

    make -j"$(nproc)"

make install

ldconfig