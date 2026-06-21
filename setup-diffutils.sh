echo "Download & Install Diffutils"

[ -f "$LFS/tmp/diffutils.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz \
     -O "$LFS/tmp/diffutils.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/diffutils.tar.xz

mkdir -p build-diffutils
cd build-diffutils

$LFS/pkgs/diffutils-3.12/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install