echo "Download & Install bison"

[ -f "$LFS/tmp/bison.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz \
     -O "$LFS/tmp/bison.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/bison.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-bison.sh