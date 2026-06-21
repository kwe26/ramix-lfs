echo "Setting Up BinUtils"
wget https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.xz -O ./tmp/binutils.tar.xz
cd pkgs
tar -xf ../tmp/binutils.tar.xz
cd binutils-*
./configure \
  --prefix=/usr \
  --disable-nls

make -j$(nproc)

make DESTDIR=$LFS/build install