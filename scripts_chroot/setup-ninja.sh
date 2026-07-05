cd /pkgs
cd ninja-*

python3 configure.py --bootstrap

install -Dm755 ninja /usr/bin/ninja

ldconfig


ninja --version