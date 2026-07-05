echo "Download & Install Linux-PAM"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/sync-pkgconf.sh"

[ -f "$LFS/tmp/linux-pam.tar.xz" ] || \
wget https://github.com/linux-pam/linux-pam/releases/download/v1.7.2/Linux-PAM-1.7.2.tar.xz \
     -O "$LFS/tmp/linux-pam.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/linux-pam.tar.xz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-pam.sh"