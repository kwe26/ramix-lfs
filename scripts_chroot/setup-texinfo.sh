cd /pkgs
cd texinfo-*

./configure --prefix=/usr

make -j"$(nproc)"

make install

ldconfig