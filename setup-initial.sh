sudo dnf install \
bash binutils bison coreutils diffutils findutils gawk gcc gcc-c++ \
grep gzip m4 make patch perl python3 sed tar texinfo xz \
gmp-devel mpfr-devel libmpc-devel ncurses-devel wget git \
bzip2 which file
sudo dnf install grub2-efi-x64 grub2-tools xorriso
sudo dnf install glibc-static squashfs-tools
export LFS=$(pwd)
mkdir pkgs
mkdir -pv $LFS/{pkgs,build,tools,tmp}
mkdir -p "$LFS/build"
cp "$LFS/init" "$LFS/build/init"
chmod +x "$LFS/build/init"

mkdir -p out

grub2-mkrescue \
    -o "$LFS/out/Ramix.iso" \
    "$LFS/iso"