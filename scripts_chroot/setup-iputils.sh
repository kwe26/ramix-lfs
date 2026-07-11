cd /pkgs/iputils-20250605

meson setup build \
    --prefix=/usr \
    -DBUILD_PING=true \
    -DBUILD_TRACEPATH=false \
    -DBUILD_MANS=false

ninja -C build

ninja -C build install

setcap cap_net_raw+p /usr/bin/ping || true