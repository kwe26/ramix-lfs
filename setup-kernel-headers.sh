echo "Downloading the Linux Kernel"
echo "Version : 7.1.1"
wget https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.1.1.tar.xz -O $LFS/tmp/kernel.tar.xz
cd $LFS/pkgs
tar -xf $LFS/tmp/kernel.tar.xz 
cd $LFS/pkgs/linux-*
make mrproper
make headers
# find usr/include -type f ! -name '*.h' -delete
mkdir -p $LFS/build/usr/include
find usr/include -type f -name '*.h' -exec \
    cp --parents {} "$LFS/build/usr/include" \;
