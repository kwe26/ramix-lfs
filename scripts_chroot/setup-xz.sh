cd /pkgs
cd xz-*

./configure \
    --prefix=/usr \
    --disable-static

make -j$(nproc)
make install

ldconfig