cd /pkgs
cd libseccomp-*

mkdir -p build
cd build

../configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-static

make -j"$(nproc)"

make install

ldconfig