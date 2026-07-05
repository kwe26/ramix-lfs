echo "Download & Install Shadow"

export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/sync-pkgconf.sh"

[ -f "$LFS/tmp/shadow.tar.xz" ] || \
wget https://github.com/shadow-maint/shadow/releases/download/4.18.0/shadow-4.18.0.tar.xz \
     -O "$LFS/tmp/shadow.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/shadow.tar.xz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-shadow.sh"