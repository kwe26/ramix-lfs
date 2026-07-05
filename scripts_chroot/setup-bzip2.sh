cd /pkgs
cd bzip2-*

make -f Makefile-libbz2_so
make clean
make

make PREFIX=/usr install
cp -av libbz2.so.* /usr/lib/
ln -sv libbz2.so.1.0 /usr/lib/libbz2.so

cp -v bzip2-shared /usr/bin/bzip2
ln -sfv bzip2 /usr/bin/bunzip2
ln -sfv bzip2 /usr/bin/bzcat

ldconfig