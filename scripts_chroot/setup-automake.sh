cd /pkgs
cd automake-*

./configure \
    --prefix=/usr

make -j"$(nproc)"

make install

ldconfig