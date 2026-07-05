echo "Download & Install libmd"

[ -f "$LFS/tmp/libmd.tar.xz" ] || \
wget https://libbsd.freedesktop.org/releases/libmd-1.1.0.tar.xz \
     -O "$LFS/tmp/libmd.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/libmd.tar.xz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-libmd.sh"


sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/sync-pkgconf.sh"

echo "Download & Install libbsd"

[ -f "$LFS/tmp/libbsd.tar.xz" ] || \
wget https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz \
     -O "$LFS/tmp/libbsd.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/libbsd.tar.xz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-libbsd.sh"

     sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/sync-pkgconf.sh"