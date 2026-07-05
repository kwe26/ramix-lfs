echo "Download & Install libseccomp"

[ -f "$LFS/tmp/libseccomp.tar.gz" ] || \
wget https://github.com/seccomp/libseccomp/releases/download/v2.6.0/libseccomp-2.6.0.tar.gz \
     -O "$LFS/tmp/libseccomp.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/libseccomp.tar.gz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-libseccomp.sh"