# echo "Downloading Glibc-2.43"
# wget "https://ftp.gnu.org/gnu/glibc/glibc-2.43.tar.xz" -O $LFS/tmp/glibc.tar.xz
# cd $LFS/pkgs
# tar -xf $LFS/tmp/glibc.tar.xz
cd $LFS/pkgs/glibc-*

sed -i '/#define OPEN_TREE_CLONE/,/#define OPEN_TREE_CLOEXEC/c\
#ifndef OPEN_TREE_CLONE\
#define OPEN_TREE_CLONE    (1 << 0)\
#endif\
\
#ifndef OPEN_TREE_CLOEXEC\
#define OPEN_TREE_CLOEXEC  O_CLOEXEC\
#endif' \
"$LFS/pkgs/glibc-2.43/sysdeps/unix/sysv/linux/sys/mount.h"

mkdir -p build/
cd build/

../configure \
    --prefix=/usr \
    --with-headers=$LFS/build/usr/include

# Compile GLIBC

make -j$(nproc)
make DESTDIR=$LFS/build install