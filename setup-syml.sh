cd $LFS/build

mkdir -pv $LFS/build/{boot,dev,home,mnt,opt,proc,root,run,srv,sys,tmp}

mkdir -pv $LFS/build/usr/{bin,include,lib,lib64,sbin,share,src}

mkdir -pv $LFS/build/usr/share/{doc,info,locale,man}

mkdir -pv $LFS/build/usr/share/man/man{1..8}

mkdir -pv $LFS/build/var/{cache,lib,local,log,mail,opt,spool,tmp}

mkdir -pv $LFS/build/etc/{profile.d,sysconfig}

mkdir -pv boot dev etc home mnt opt proc root run srv sys tmp var

ln -sf usr/bin bin
ln -sf usr/sbin sbin
ln -sf usr/lib  lib

cat > $LFS/build/etc/shells <<'EOF'
/usr/bin/bash
/bin/bash
EOF

cat > $LFS/build/etc/hosts <<'EOF'
127.0.0.1 localhost
127.0.1.1 ramix
::1 localhost
EOF

echo "ramix" > $LFS/build/etc/hostname

cat > $LFS/build/etc/os-release <<'EOF'
NAME="Ramix"
VERSION="0.1"
ID=ramix
PRETTY_NAME="Ramix Linux"
EOF

cat > $LFS/build/etc/ld.so.conf <<'EOF'
/usr/lib64
/usr/lib
/lib64
/lib
EOF