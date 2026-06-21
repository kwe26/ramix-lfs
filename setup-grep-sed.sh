echo "Download & Install grep"

[ -f "$LFS/tmp/grep.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz \
     -O "$LFS/tmp/findutils.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/grep.tar.xz

mkdir -p build-grep
cd build-grep

$LFS/pkgs/grep-3.12/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install

echo "Download & Install sed"

[ -f "$LFS/tmp/sed.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/sed/sed-4.10.tar.xz \
     -O "$LFS/tmp/sed.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/sed.tar.xz

mkdir -p build-sed
cd build-sed

$LFS/pkgs/sed-4.10/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install


echo "Download & Install gawk"

[ -f "$LFS/tmp/gawk.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/gawk/gawk-5.4.0.tar.xz \
     -O "$LFS/tmp/gawk.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/gawk.tar.xz

mkdir -p build-gawk
cd build-gawk

$LFS/pkgs/gawk-5.4.0/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install