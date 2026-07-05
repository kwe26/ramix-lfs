cd /pkgs
cd kmod-*

mkdir -p build

mkdir -p /usr/lib64/pkgconfig

ln -sf /usr/lib/pkgconfig/libzstd.pc \
       /usr/lib64/pkgconfig/libzstd.pc

ln -sf /usr/lib/pkgconfig/liblzma.pc \
       /usr/lib64/pkgconfig/liblzma.pc

ln -sf /usr/lib/pkgconfig/zlib.pc \
       /usr/lib64/pkgconfig/zlib.pc

ln -sf /usr/lib/pkgconfig/libssl.pc\
       /usr/lib64/pkgconfig/libssl.pc

       ln -sf /usr/lib/pkgconfig/openssl.pc\
       /usr/lib64/pkgconfig/openssl.pc

       ln -sf /usr/lib/pkgconfig/libcrypto.pc\
       /usr/lib64/pkgconfig/libcrypto.pc

./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --libdir=/usr/lib \
    --with-zstd \
    --with-xz \
    --with-zlib \
    --disable-manpages \
    --with-openssl

make -j"$(nproc)"

make install

ldconfig

ldconfig