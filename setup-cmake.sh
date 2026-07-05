echo "Download & Install cmake"

[ -f "$LFS/tmp/rhash.tar.gz" ] || \
wget https://github.com/rhash/RHash/archive/refs/tags/v1.4.6.tar.gz \
     -O "$LFS/tmp/rhash.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/rhash.tar.gz

[ -f "$LFS/tmp/cmake.tar.gz" ] || \
wget https://github.com/Kitware/CMake/releases/download/v4.3.4/cmake-4.3.4.tar.gz \
     -O "$LFS/tmp/cmake.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/cmake.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-cmake.sh