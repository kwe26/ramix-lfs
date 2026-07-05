echo "Download & Install libffi"

[ -f "$LFS/tmp/libffi.tar.gz" ] || \
wget https://github.com/libffi/libffi/releases/download/v3.5.2/libffi-3.5.2.tar.gz \
     -O "$LFS/tmp/libffi.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/libffi.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-libffi.sh