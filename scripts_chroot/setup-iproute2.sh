cd /pkgs
cd iproute2-*

sed -i \
    -e '/HAVE_MNL/s/^/#/' \
    -e '/HAVE_BPF/s/^/#/' \
    config.mk

make -j"$(nproc)"

make install