echo "Download & Install Coreutils"

[ -f "$LFS/tmp/coreutils.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.11.tar.xz \
     -O "$LFS/tmp/coreutils.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/coreutils.tar.xz

mkdir -p build-coreut
cd build-coreut

$LFS/pkgs/coreutils-9.11/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install