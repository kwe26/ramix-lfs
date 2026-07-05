cd /pkgs
cd shadow-*

mkdir -p build
cd build

../configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --with-group-name-max-length=32 \
    --disable-static

make -j"$(nproc)"

make install

#
# Default login configuration
#

install -dm755 /etc/default

cat >/etc/default/useradd <<EOF
GROUP=1000
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/bash
SKEL=/etc/skel
CREATE_MAIL_SPOOL=no
EOF

mkdir -p /etc/skel

touch /etc/login.defs || true

ldconfig