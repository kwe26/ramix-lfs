# export CPPFLAGS="-I$LFS/build/usr/include"
# export LDFLAGS="-L$LFS/build/usr/lib64 -L$LFS/build/usr/lib"
# export LD_LIBRARY_PATH="$LFS/build/usr/lib64:$LFS/build/usr/lib"

echo $CPPFLAGS;
echo $LDFLAGS;
echo $LD_LIBRARY_PATH;

[ -f "$LFS/tmp/gcc.tar.gz" ] || \
wget https://ftp.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.gz \
     -O "$LFS/tmp/gcc.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/gcc.tar.gz

cd $LFS/pkgs/gcc-*

mkdir -p ../build-gcc
cd ../build-gcc

$LFS/pkgs/gcc-16.1.0/configure \
    --prefix=/usr \
    --disable-multilib \
    --disable-bootstrap \
    --enable-languages=c,c++ \
    --with-gmp="$LFS/build/usr" \
    --with-mpfr="$LFS/build/usr" \
    --with-mpc="$LFS/build/usr"

make -j$(nproc)

make DESTDIR="$LFS/build" install