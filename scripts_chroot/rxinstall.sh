#!/usr/bin/env bash
set -Eeuo pipefail

echo " Installing RX Packages"
echo

PACKAGES=(
    linux-api-headers-7.1.1-1.rx
    glibc-2.43-1.rx
    ncurses-6.6-1.rx
    readline-8.3-1.rx
    bash-5.3.0-1.rx
    ca-certificates-20250630-1.rx
    zlib-1.3.2-1.rx
    openssl-3.5.7-1.rx
)

for pkg in "${PACKAGES[@]}"; do
    echo "==> Installing $pkg"
    rxpkg install "/pkgs/.rx/$pkg"
    echo
done

echo "All packages installed."