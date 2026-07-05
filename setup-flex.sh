echo "Download & Install flex"

[ -f "$LFS/tmp/flex.tar.gz" ] || \
wget https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz \
     -O "$LFS/tmp/flex.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/flex.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-flex.sh