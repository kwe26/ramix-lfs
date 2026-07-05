echo "Download & Install curl"

[ -f "$LFS/tmp/curl.tar.xz" ] || \
wget https://curl.se/download/curl-8.21.0.tar.xz \
     -O "$LFS/tmp/curl.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/curl.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-curl.sh