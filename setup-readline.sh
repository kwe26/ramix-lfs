echo "Download & Install Readline"

[ -f "$LFS/tmp/readline.tar.gz" ] || \
wget https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz \
     -O "$LFS/tmp/readline.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/readline.tar.gz

cd $LFS/pkgs/readline-*

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.3

make -j$(nproc)

make PREFIX=/usr DESTDIR="$LFS/build" install

cd "$LFS/build/usr/lib64"

ln -sf ../lib/libzstd.so.1 libzstd.so.1
ln -sf ../lib/libzstd.so libzstd.so