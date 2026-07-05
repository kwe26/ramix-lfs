cd /pkgs
cd Python-*

./configure \
    --prefix=/usr \
    --enable-shared \
    --with-openssl=/usr \
    --with-system-ffi \
    --enable-ipv6 \
    --with-ensurepip=install

make -j$(nproc)
make install

ldconfig

echo "========================================"
echo " Python Installed Successfully"
echo "========================================"

python3 --version

python3 -c "import ssl; print('ssl       : OK')"
python3 -c "import sqlite3; print('sqlite3   : OK')"
python3 -c "import bz2; print('bz2       : OK')"
python3 -c "import lzma; print('lzma      : OK')"
python3 -c "import zlib; print('zlib      : OK')"
python3 -c "import readline; print('readline  : OK')"
python3 -c "import ctypes; print('ctypes    : OK')"