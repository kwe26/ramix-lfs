echo "Download & Install util-linux"

[ -f "$LFS/tmp/utillinux.tar.gz" ] || \
wget https://github.com/util-linux/util-linux/archive/refs/tags/v2.42.2.tar.gz \
     -O "$LFS/tmp/utillinux.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/utillinux.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-utillinux.sh