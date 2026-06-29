cd "$LFS/build"

rm $LFS/boot/rootfs.squashfs

sudo umount -lf "$LFS/build/pkgs"
sudo umount -lf "$LFS/build/tmp"
sudo umount -lf "$LFS/build/dev/pts"
sudo umount -lf "$LFS/build/dev"
sudo umount -lf "$LFS/build/proc"
sudo umount -lf "$LFS/build/sys"

sudo chroot "$LFS/build" /sbin/ldconfig

mksquashfs \
    "$LFS/build" \
    "$LFS/boot/rootfs.squashfs" \
    -comp zstd \
    -Xcompression-level 15 \
    -b 1M

file "$LFS/boot/initramfs.img"

mkdir -p "$LFS/boot/grub"
cp "$LFS/grub.cfg" "$LFS/boot/grub/grub.cfg"

mkdir -p "$LFS/iso/boot/grub"

cp $LFS/init $LFS/build/init
chmod a+x $LFS/build/init

cp "$LFS/boot/bzImage" "$LFS/iso/boot/"
cp "$LFS/boot/initramfs.img" "$LFS/iso/boot/"
cp "$LFS/boot/rootfs.squashfs" "$LFS/iso/boot/"
cp "$LFS/grub.cfg" "$LFS/iso/boot/grub/grub.cfg"

grub2-mkrescue \
    -o "$LFS/Ramix.iso" \
    "$LFS/iso"