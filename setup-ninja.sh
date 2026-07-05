echo "Download & Install NINJA"

[ -f "$LFS/tmp/ninja.tar.gz" ] || \
wget https://github.com/ninja-build/ninja/archive/refs/tags/v1.13.1.tar.gz \
     -O "$LFS/tmp/ninja.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/ninja.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-ninja.sh