cd /pkgs
cd libmd-*


./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-static

make -j"$(nproc)"
make install

ldconfig
