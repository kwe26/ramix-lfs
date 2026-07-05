cd /pkgs
cd bison-*

./configure \
    --prefix=/usr \
    --disable-static

make -j"$(nproc)"

make install

ldconfig

bison --version

# ln -sf bison /usr/bin/yacc