echo "Download & Install iproute2"

[ -f "$LFS/tmp/iproute2.tar.xz" ] || \
wget https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-7.1.0.tar.xz \
    -O "$LFS/tmp/iproute2.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/iproute2.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/setup-iproute2.sh"