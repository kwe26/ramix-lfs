export LFS=$(pwd)

sudo mount -t squashfs -o loop \
    "$LFS/boot/rootfs.squashfs" \
    /mnt

sudo cp -a /mnt/. "$LFS/build/"

sudo umount /mnt