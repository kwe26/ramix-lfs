#!/bin/sh
set -e

ln -sf /usr/lib/systemd/systemd /usr/sbin/init
ln -sf /usr/lib/systemd/systemd /usr/bin/init

touch /etc/machine-id
echo ramix > /etc/hostname

mkdir -p /etc/systemd/system
mkdir -p /var/log
mkdir -p /var/lib/systemd
mkdir -p /run

cat >> /etc/profile <<'EOF'
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
EOF

touch /etc/group

grep -q '^root:'  /etc/group || echo 'root:x:0:'      >> /etc/group
grep -q '^users:' /etc/group || echo 'users:x:100:'   >> /etc/group
grep -q '^wheel:' /etc/group || echo 'wheel:x:10:'    >> /etc/group
grep -q '^ramix:' /etc/group || echo 'ramix:x:1000:'  >> /etc/group

touch /etc/passwd
touch /etc/shadow

if getent passwd root >/dev/null 2>&1; then
    usermod -d /root -s /bin/bash root
else
    useradd -m -u 0 -g 0 -d /root -s /bin/bash root
fi

mkdir -p /root
chown root:root /root
chmod 700 /root

passwd -d root

if ! getent passwd ramix >/dev/null 2>&1; then
    useradd \
        -m \
        -u 1000 \
        -g ramix \
        -G users,wheel \
        -s /bin/bash \
        ramix
fi

chmod 0400 /etc/shadow

echo "ramix:ramix" | chpasswd

cat > /etc/securetty <<'EOF'
tty0
tty1
tty2
tty3
tty4
tty5
tty6
ttyS0
EOF

rm -rf /etc/systemd/system/getty@tty1.service.d

ln -sf /usr/sbin/agetty /sbin/agetty

cat > /etc/pam.d/system-auth <<'EOF'
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok
auth        required      pam_deny.so

account     required      pam_unix.so

password    required      pam_unix.so shadow nullok

session     required      pam_limits.so
session     required      pam_unix.so
session     optional      pam_umask.so
EOF

cat > /etc/nsswitch.conf <<'EOF'
passwd:     files
group:      files
shadow:     files

hosts:      files dns

networks:   files
protocols:  files
services:   files
EOF

systemctl enable getty@tty1.service

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

mkdir -p /etc/systemd/network

cat > /etc/systemd/network/20-wired.network <<'EOF'
[Match]
Name=e*

[Network]
DHCP=yes
IPv6AcceptRA=yes
EOF

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf