cd /pkgs
cd libbsd-*

./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-static

make -j"$(nproc)"

make install

ldconfig