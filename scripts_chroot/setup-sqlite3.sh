cd /pkgs
cd sqlite-autoconf-*

./configure \
    --prefix=/usr \
    --disable-static \
    --enable-threadsafe 

make -j$(nproc)
make install

ldconfig

sqlite3 --version

pkg-config --modversion sqlite3