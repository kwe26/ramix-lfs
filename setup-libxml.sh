echo "Download & Build libxml2"

LIBXML_VERSION="2.15.3"

[ -f "$LFS/tmp/libxml2.tar.xz" ] || \
wget https://download.gnome.org/sources/libxml2/2.15/libxml2-${LIBXML_VERSION}.tar.xz \
    -O "$LFS/tmp/libxml2.tar.xz"

cd "$LFS/pkgs"

rm -rf libxml2-*

tar -xf "$LFS/tmp/libxml2.tar.xz"

sudo "$LFS/invoke-chroot.sh" "$LFS/scripts_chroot/setup-libxml2.sh"