#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd seatd-*

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Dserver=enabled 

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig

install -Dm644 /dev/stdin \
    /usr/lib/systemd/system/seatd.service <<'EOF'
[Unit]
Description=seat management daemon
Documentation=man:seatd(1)
After=local-fs.target
Before=graphical.target

[Service]
Type=simple
ExecStart=/usr/sbin/seatd -g video
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl enable seatd

echo 