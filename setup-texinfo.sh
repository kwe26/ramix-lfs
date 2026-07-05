echo "Download & Install texinfo"

[ -f "$LFS/tmp/texinfo.tar.xz" ] || \
wget https://ftp.gnu.org/pub/gnu/texinfo/texinfo-7.3.tar.xz \
     -O "$LFS/tmp/texinfo.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/texinfo.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-texinfo.sh