echo "Download & Install systemd"

[ -f "$LFS/tmp/systemd.tar.gz" ] || \
wget https://github.com/systemd/systemd/archive/refs/tags/v261.1.tar.gz \
     -O "$LFS/tmp/systemd.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/systemd.tar.gz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-systemd.sh"