sudo dnf install \
bash binutils bison coreutils diffutils findutils gawk gcc gcc-c++ \
grep gzip m4 make patch perl python3 sed tar texinfo xz \
gmp-devel mpfr-devel libmpc-devel ncurses-devel wget git \
bzip2 which file
export LFS=$(pwd)
mkdir pkgs
mkdir -pv $LFS/{pkgs,build,tools,tmp}
ln -sfn $LFS/pkgs $LFS/sources