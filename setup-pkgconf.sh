echo "Download & Install Pkgconf"

[ -f "$LFS/tmp/pkgconf.tar.xz" ] || \
wget https://distfiles.ariadne.space/pkgconf/pkgconf-2.5.1.tar.xz \
     -O "$LFS/tmp/pkgconf.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/pkgconf.tar.xz

mkdir -p build-pconf
cd build-pconf

$LFS/pkgs/pkgconf-2.5.1/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install