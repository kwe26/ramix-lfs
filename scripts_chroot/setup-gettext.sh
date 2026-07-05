cd /pkgs
cd gettext-*

./configure \
    --prefix=/usr \
    --disable-static

make -j$(nproc)
make install

ldconfig