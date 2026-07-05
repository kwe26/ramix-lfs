echo "Download & Install e2fsprogs"

[ -f "$LFS/tmp/e2fsprogs.tar.gz" ] || \
wget https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.3/e2fsprogs-1.47.3.tar.gz  \
     -O "$LFS/tmp/e2fsprogs.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/e2fsprogs.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-e2fsprogs.sh