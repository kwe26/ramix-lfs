cd /pkgs
cd libffi-*

./configure \
    --prefix=/usr \
    --disable-static

make -j$(nproc)
make install

ldconfig