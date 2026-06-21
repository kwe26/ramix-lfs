echo "Download & Install M4"

[ -f "$LFS/tmp/m4.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/m4/m4-1.4.21.tar.xz \
     -O "$LFS/tmp/m4.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/m4.tar.xz

mkdir -p build-m4
cd build-m4

$LFS/pkgs/m4-1.4.21/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install