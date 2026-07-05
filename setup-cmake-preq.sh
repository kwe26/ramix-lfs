echo "Download & Install Expat"

[ -f "$LFS/tmp/expat.tar.gz" ] || \
wget https://github.com/libexpat/libexpat/releases/download/R_2_8_2/expat-2.8.2.tar.gz \
     -O "$LFS/tmp/expat.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/expat.tar.gz

echo "Download & Install libuv"

[ -f "$LFS/tmp/libuv.tar.gz" ] || \
wget https://github.com/libuv/libuv/archive/refs/tags/v1.52.1.tar.gz \
     -O "$LFS/tmp/libuv.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/libuv.tar.gz

echo "Download & Install libarchive"

[ -f "$LFS/tmp/libarchive.tar.gz" ] || \
wget https://github.com/libarchive/libarchive/releases/download/v3.8.8/libarchive-3.8.8.tar.xz \
     -O "$LFS/tmp/libarchive.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/libarchive.tar.gz

echo "Download & Install jsoncpp"

[ -f "$LFS/tmp/jsoncpp.tar.gz" ] || \
wget https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/1.9.8.tar.gz \
     -O "$LFS/tmp/jsoncpp.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/jsoncpp.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-cmake-preq.sh