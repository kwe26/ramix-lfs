echo "Download & Install Wayland"

[ -f "$LFS/tmp/wayland.tar.xz" ] || \
wget https://gitlab.freedesktop.org/wayland/wayland/-/archive/1.26.0/wayland-1.26.0.tar.gz \
    -O "$LFS/tmp/wayland.tar.gz"

cd "$LFS/pkgs"

rm -rf wayland-*

tar -xf "$LFS/tmp/wayland.tar.gz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/setup-wayland.sh"