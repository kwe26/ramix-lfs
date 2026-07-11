qemu-system-x86_64 \
    -cpu host \
    -m 2G \
    -cdrom Ramix.iso \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 \
    -enable-kvm 