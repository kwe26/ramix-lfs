echo "Download & Install Bash"

[ -f "$LFS/tmp/bash.tar.gz" ] || \
wget https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz \
     -O "$LFS/tmp/bash.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/bash.tar.gz

mkdir -p build-bash
cd build-bash

$LFS/pkgs/bash-5.3/configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install