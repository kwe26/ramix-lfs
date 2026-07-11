echo "Download & Install iputils"

[ -f "$LFS/tmp/iputils.tar.gz" ] || \
wget https://github.com/iputils/iputils/archive/refs/tags/20250605.tar.gz \
    -O "$LFS/tmp/iputils.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/iputils.tar.gz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/setup-iputils.sh"