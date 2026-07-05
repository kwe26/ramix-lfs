cd /pkgs
cd libtool-*

./configure \
    --prefix=/usr

make -j"$(nproc)"

make install

ldconfig