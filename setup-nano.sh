echo "Download & Install GNU NANO"

[ -f "$LFS/tmp/nano.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/nano/nano-9.1.tar.xz \
     -O "$LFS/tmp/nano.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/nano.tar.xz

mkdir -p build-nano
cd build-nano

$LFS/pkgs/nano-9.1/configure \
    --prefix=/usr \ 
    --enable-static \ 
    --without-zlib

make -j$(nproc)
make DESTDIR=$LFS/build install