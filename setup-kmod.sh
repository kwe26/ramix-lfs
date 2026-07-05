echo "Download & Install kmod"

[ -f "$LFS/tmp/kmod.tar.gz" ] || \
wget https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.2.tar.gz \
     -O "$LFS/tmp/kmod.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/kmod.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-kmod.sh