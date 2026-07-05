echo "Download & Install meson"

wget https://files.pythonhosted.org/packages/source/s/setuptools/setuptools-80.9.0.tar.gz -O "$LFS/tmp/setuptools.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/setuptools.tar.gz

[ -f "$LFS/tmp/meson.tar.gz" ] || \
wget https://github.com/mesonbuild/meson/releases/download/1.11.1/meson-1.11.1.tar.gz \
     -O "$LFS/tmp/meson.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/meson.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-meson.sh