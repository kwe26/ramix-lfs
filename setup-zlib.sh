echo "Download & Install ZLIB"

[ -f "$LFS/tmp/zlib.tar.gz" ] || \
wget https://zlib.net/zlib-1.3.2.tar.gz \
     -O "$LFS/tmp/zlib.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/zlib.tar.gz

cd $LFS/pkgs/zlib-*

./configure --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install