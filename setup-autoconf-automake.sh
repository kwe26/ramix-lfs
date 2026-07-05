echo "Download & Install AutoConf"

[ -f "$LFS/tmp/autoconf.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.73.tar.xz \
     -O "$LFS/tmp/autoconf.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/autoconf.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-autoconf.sh

echo "Download & Install automake"

[ -f "$LFS/tmp/automake.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/automake/automake-1.18.1.tar.xz \
     -O "$LFS/tmp/automake.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/automake.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-automake.sh

echo "Download & Install libtool"

[ -f "$LFS/tmp/libtool.tar.xz" ] || \
wget https://ftp.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz \
     -O "$LFS/tmp/libtool.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/libtool.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-libtool.sh