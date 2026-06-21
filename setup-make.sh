echo "Download & Install Make"

[ -f "$LFS/tmp/make.tar.gz" ] || \
wget https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz \
     -O "$LFS/tmp/make.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/make.tar.gz

mkdir -p build-make
cd build-make

$LFS/pkgs/make-4.4.1/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install