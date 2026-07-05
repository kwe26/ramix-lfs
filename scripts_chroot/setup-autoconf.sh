cd /pkgs
cd autoconf-*

./configure \
    --prefix=/usr

make -j"$(nproc)"

make install

ldconfig