cd /pkgs
cd setuptools-*

python3 -m pip install --no-build-isolation .

cd /pkgs
cd meson-*

python3 -m pip install \
    --no-build-isolation \
    --no-deps \
    --prefix=/usr \
    .

meson --version