echo "Download & Install gettext"

[ -f "$LFS/tmp/gettext.tar.gz" ] || \
wget https://ftp.gnu.org/gnu/gettext/gettext-1.0.tar.gz \
     -O "$LFS/tmp/gettext.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/gettext.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-gettext.sh