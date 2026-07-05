cd /pkgs
cd libcap-*

echo "========================================"
echo " Building libcap"
echo "========================================"

make \
    prefix=/usr \
    lib=lib \
    PAM_CAP=no \
    RAISE_SETFCAP=no \
    -j"$(nproc)"

make \
    prefix=/usr \
    lib=lib \
    PAM_CAP=no \
    RAISE_SETFCAP=no \
    install

ldconfig

cd /pkgs
cd libxcrypt-*

echo "========================================"
echo " Building libxcrypt"
echo "========================================"

./configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --disable-static \
    CFLAGS="-O2 -g -Wno-error"

make CFLAGS="-O2 -g -Wno-error" -j$(nproc)

make install

ldconfig