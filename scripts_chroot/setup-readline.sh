cd /pkgs
cd readline-*

./configure \
    --prefix=/usr \
    --disable-static \
    --with-curses \
    --docdir=/usr/share/doc/readline-8.3

make -j"$(nproc)"

make install

ldconfig

readline_ver=$(grep '^#define RL_READLINE_VERSION' /usr/include/readline/readline.h | awk '{print $3}' || true)
echo "Readline version macro: ${readline_ver:-unknown}"

echo
echo "Installed libraries:"
find /usr/lib /usr/lib64 -maxdepth 1 \( -name "libreadline*" -o -name "libhistory*" \) 2>/dev/null

echo
echo "Dynamic linker:"
ldconfig -p | grep -E 'readline|history' || true

echo
echo "pkg-config:"
pkg-config --modversion readline 2>/dev/null || echo "No readline.pc installed."