echo "Download & Install ZSTD"

[ -f "$LFS/tmp/zstd.tar.gz" ] || \
wget https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz \
     -O "$LFS/tmp/zstd.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/zstd.tar.gz

cd $LFS/pkgs/zstd-*

make -j$(nproc)

make PREFIX=/usr DESTDIR="$LFS/build" install

cd "$LFS/build/usr/lib64"

ln -sf ../lib/libzstd.so.1 libzstd.so.1
ln -sf ../lib/libzstd.so libzstd.so