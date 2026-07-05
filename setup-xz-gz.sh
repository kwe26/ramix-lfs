echo "Download & Install BZIP2"

[ -f "$LFS/tmp/bzip2.tar.gz" ] || \
wget https://sourceware.org/pub/bzip2/bzip2-latest.tar.gz \
     -O "$LFS/tmp/bzip2.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/bzip2.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-bzip2.sh

echo "Download & Install xz"

[ -f "$LFS/tmp/xz.tar.gz" ] || \
wget https://github.com/tukaani-project/xz/releases/download/v5.8.3/xz-5.8.3.tar.gz \
     -O "$LFS/tmp/xz.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/xz.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-xz.sh