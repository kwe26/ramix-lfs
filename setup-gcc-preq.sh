# Setup GCC Pre-quiestes
echo "Downloading GMP"
wget https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz -O $LFS/tmp/gmp.tar.xz
cd $LFS/pkgs
tar -xf $LFS/tmp/gmp.tar.xz

cd $LFS/pkgs/gmp-*

echo "Applying GCC 15/16 compatibility patch to GMP"

cd "$LFS/pkgs/gmp-6.3.0"

if ! grep -q "void g(int,t1 const\\*,t1,t2,t1 const\\*,int)" configure; then
    patch -Np1 -i "$LFS/gmp-gcc15.patch"

    sed -i \
    's|void g(){}|void g(int,t1 const*,t1,t2,t1 const*,int){}|g' \
    configure
else
    echo "Patch already applied, skipping."
fi

mkdir -p build
cd build


../configure \
    --prefix=/usr

make -j$(nproc)
make DESTDIR=$LFS/build install

echo "Downloading and Compiling MPFR"

wget https://www.mpfr.org/mpfr-current/mpfr-4.2.2.tar.xz -O $LFS/tmp/mpfr.tar.xz
cd $LFS/pkgs
tar -xf $LFS/tmp/mpfr.tar.xz
cd $LFS/pkgs/mpfr-*

mkdir -p build
cd build

../configure \
    --prefix=/usr \
    --with-gmp=$LFS/build/usr

make -j$(nproc)
make DESTDIR=$LFS/build install

echo "Downloading and Installing MPC"
cd $LFS/pkgs
wget https://ftp.gnu.org/gnu/mpc/mpc-1.4.1.tar.xz -O $LFS/tmp/mpc.tar.xz

tar -xf $LFS/tmp/mpc.tar.xz
cd $LFS/pkgs/mpc-*
mkdir -p build
cd build

../configure \
    --prefix=/usr \
    --with-gmp=$LFS/build/usr \
    --with-mpfr=$LFS/build/usr 

make -j$(nproc)
make DESTDIR=$LFS/build install