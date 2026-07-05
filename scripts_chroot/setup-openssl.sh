cd /pkgs
cd openssl-*

./Configure \
    --prefix=/usr \
    --libdir=lib \
    shared \
    zlib \
    linux-x86_64

make -j$(nproc)
make install

ldconfig

openssl version