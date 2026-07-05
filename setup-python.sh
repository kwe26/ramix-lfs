echo "Download & Install Python3"

[ -f "$LFS/tmp/python3.tar.xz" ] || \
wget https://www.python.org/ftp/python/3.13.14/Python-3.13.14.tar.xz \
     -O "$LFS/tmp/python3.tar.xz"

cd $LFS/pkgs

tar -xf $LFS/tmp/python3.tar.xz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-python3.sh