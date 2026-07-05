cd /pkgs
cd expat-*

./configure \
    --prefix=/usr \
    --disable-static

make -j"$(nproc)"
make install

ldconfig

cd /pkgs
cd libuv-*

sh autogen.sh

./configure \
    --prefix=/usr \
    --disable-static

make -j"$(nproc)"
make install

ldconfig

cd /pkgs
cd libarchive-*

./configure \
    --prefix=/usr \
    --disable-static

make -j"$(nproc)"
make install

ldconfig

cd /pkgs
cd jsoncpp-*

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Ddefault_library=shared \
    -Dtests=false

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig
