echo "Download & Install NCURSES"

[ -f "$LFS/tmp/ncurses.tar.gz" ] || \
wget https://ftp.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz \
     -O "$LFS/tmp/ncurses.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/ncurses.tar.gz

mkdir -p build-ncurses
cd build-ncurses

$LFS/pkgs/ncurses-6.6/configure \
    --prefix=/usr   \
    --with-manpage-format=normal \
    --with-shared                \
    --without-normal             \
    --with-cxx-shared            \
    --without-debug              \
    --without-ada                \
    --with-termlib \
    --disable-stripping          \
    --enable-pc-files

make -j$(nproc)
make DESTDIR=$LFS/build install

cd "$LFS/build/usr/lib64"

ln -sf libtinfow.so.6 libtinfo.so.6
ln -sf libtinfow.so libtinfo.so