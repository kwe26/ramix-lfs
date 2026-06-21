echo "Download & Install findutils"

[ -f "$LFS/tmp/findutils.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz \
     -O "$LFS/tmp/findutils.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/findutils.tar.xz

mkdir -p build-findutils
cd build-findutils

$LFS/pkgs/findutils-4.10.0/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install