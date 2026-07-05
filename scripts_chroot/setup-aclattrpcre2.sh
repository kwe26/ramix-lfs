cd /pkgs
cd attr-*

./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-static

make -j"$(nproc)"

make install

ldconfig


cd /pkgs
cd acl-*

./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-static

make -j"$(nproc)"

make install

ldconfig

cd /pkgs
cd pcre2-*

./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-static \
    --enable-pcre2-8 \
    --enable-pcre2-16 \
    --enable-pcre2-32 \
    --enable-jit

make -j"$(nproc)"

make install