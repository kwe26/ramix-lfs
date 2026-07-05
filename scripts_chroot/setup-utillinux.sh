cd /pkgs
cd util-linux-*

sh autogen.sh

./configure \
    ADJTIME_PATH=/var/lib/hwclock/adjtime \
    --prefix=/usr \
    --bindir=/usr/bin \
    --libdir=/usr/lib \
    --runstatedir=/run \
    --sbindir=/usr/sbin \
    --disable-static \
    --disable-pylibmount \
    --without-python \
    --without-systemd


make -j"$(nproc)"

make install

mkdir -p /var/lib/hwclock

ldconfig