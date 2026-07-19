qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 2 \
    -m 2G \
    -cdrom Ramix.iso \
    \
    -display gtk,gl=on \
    -device virtio-vga-gl \
    \
    -device qemu-xhci \
    \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0