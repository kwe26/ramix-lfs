cd /pkgs
cd curl-*

./configure \
    --prefix=/usr \
    --disable-static \
    --with-openssl \
    --with-zlib \
    --without-libpsl \
    --with-ca-bundle=/usr/ssl/cert.pem \
    --with-ca-path=/usr/ssl/certs

    make -j"$(nproc)"

make install

ldconfig