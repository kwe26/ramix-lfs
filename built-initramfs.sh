#!/usr/bin/env bash
[ -n "${LFS:-}" ] || {
    echo "ERROR: LFS is not set"
    exit 1
}

BUSYBOX_VERSION="1.38.0"

INITFS="$LFS/initfs"
PKGS="$LFS/pkgs"
TMP="$LFS/tmp"

echo "==================== Preparing Initramfs ===================="

rm -rf "$INITFS"
mkdir -p "$INITFS"

mkdir -p \
    "$INITFS"/{bin,sbin,etc,proc,sys,dev,mnt,newroot,tmp,usr/bin,usr/sbin}

echo "==================== Downloading BusyBox ===================="

mkdir -p "$TMP"

[ -f "$TMP/busybox.tar.bz2" ] || \
wget \
    "https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2" \
    -O "$TMP/busybox.tar.bz2"

echo "==================== Extracting BusyBox ===================="

rm -rf "$PKGS/busybox-$BUSYBOX_VERSION"

tar -xf "$TMP/busybox.tar.bz2" -C "$PKGS"

cd "$PKGS/busybox-$BUSYBOX_VERSION"

echo "==================== Configuring BusyBox ===================="

make distclean

cp $LFS/busybox.config $PKGS/busybox-$BUSYBOX_VERSION/.config

echo "==================== Building BusyBox ===================="

make -j"$(nproc)"

echo "==================== Installing BusyBox ===================="

make CONFIG_PREFIX="$INITFS" install

echo "==================== Creating /init ===================="

cat > "$INITFS/init" <<'EOF'
#!/bin/sh

mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys

echo "[Ramix] Searching for ISO..."

mkdir -p /iso
mkdir -p /newroot

mount -t iso9660 /dev/sr0 /iso

echo "[Ramix] Mounting rootfs.squashfs..."

mount -t squashfs -o loop /iso/rootfs.squashfs /newroot

echo "[Ramix] Switching root..."

exec switch_root /newroot /sbin/init

echo "[Ramix] Failed."
exec sh
EOF

chmod +x "$INITFS/init"

echo "==================== Creating Device Nodes ===================="

sudo mknod -m 600 "$INITFS/dev/console" c 5 1 || true
sudo mknod -m 666 "$INITFS/dev/null" c 1 3 || true

echo "==================== Building Initramfs ===================="

cd "$INITFS"

find . -print0 \
| cpio --null -ov --format=newc \
| gzip -9 \
> "$LFS/boot/initramfs.img"

echo "==================== Done ===================="

ls -lh "$LFS/boot/initramfs.img"