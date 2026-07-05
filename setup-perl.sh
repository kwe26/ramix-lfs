echo "Download & Install perl"

[ -f "$LFS/tmp/perl.tar.gz" ] || \
wget https://www.cpan.org/src/5.0/perl-5.42.0.tar.xz \
     -O "$LFS/tmp/perl.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/perl.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-perl.sh