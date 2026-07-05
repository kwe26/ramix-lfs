echo "Download & Install OpenSSL"

[ -f "$LFS/tmp/openssl.tar.gz" ] || \
wget https://github.com/openssl/openssl/releases/download/openssl-3.5.7/openssl-3.5.7.tar.gz \
     -O "$LFS/tmp/openssl.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/openssl.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-openssl.sh