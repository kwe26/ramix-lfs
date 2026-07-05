cd /pkgs
cd flex-*

./configure \
    --prefix=/usr \
    --disable-static

make -j"$(nproc)"

make install

ln -sf flex /usr/bin/lex

ldconfig