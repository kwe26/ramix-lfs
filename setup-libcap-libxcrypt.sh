echo "Download & Install libcap"

[ -f "$LFS/tmp/libcap.tar.xz" ] || \
wget https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.77.tar.xz \
     -O "$LFS/tmp/libcap.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/libcap.tar.xz

echo "Download & Install libxcrypt"

[ -f "$LFS/tmp/libxcrypt.tar.xz" ] || \
wget https://github.com/besser82/libxcrypt/releases/download/v4.4.38/libxcrypt-4.4.38.tar.xz \
     -O "$LFS/tmp/libxcrypt.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/libxcrypt.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-capcrypt.sh