#!/usr/bin/env bash
set -Eeuo pipefail

LFS="${LFS:-$(cd "$(dirname "$0")/.." && pwd)}"

PROJECT_DIR="$LFS/rx_package_manager"
SRC_DIR="$PROJECT_DIR/bin"

CHROOT_BIN="$LFS/build/usr/bin"
CHROOT_LIB="$LFS/build/usr/lib/rx_package_manager"

HOST_BIN="/usr/local/bin"
HOST_LIB="/usr/local/lib/rx_package_manager"

if ! command -v dart >/dev/null 2>&1; then
    echo "error: Dart SDK not found."
    exit 1
fi

mkdir -p "$CHROOT_BIN"
mkdir -p "$CHROOT_LIB"

echo "========================================="
echo " Building Ramix Package Manager"
echo "========================================="
echo

shopt -s nullglob

for dart_file in "$SRC_DIR"/*.dart; do
    name="$(basename "$dart_file")"
    exe="${name%.dart}"

    [[ "$name" == "rx_package_manager.dart" ]] && continue

    echo "→ Building $exe"

    out="$PROJECT_DIR/build/$exe"

    rm -rf "$out"

    dart build cli \
        --target="$dart_file" \
        --output="$out"

    bundle="$out/bundle"

    if [[ ! -d "$bundle/bin" ]]; then
        echo "Failed to build $exe"
        exit 1
    fi

    echo "  Installing into Ramix..."

    rm -rf "$CHROOT_LIB/$exe"

    mkdir -p "$CHROOT_LIB/$exe"

    cp -a "$bundle/." "$CHROOT_LIB/$exe/"

    ln -sf \
        "../lib/rx_package_manager/$exe/bin/$exe" \
        "$CHROOT_BIN/$exe"

    #
    # Install rxbuild on host
    #

    if [[ "$exe" == "rxbuild" ]]; then
        echo "  Installing rxbuild on host..."

        sudo mkdir -p "$HOST_LIB/$exe"

        sudo rm -rf "$HOST_LIB/$exe"

        sudo mkdir -p "$HOST_LIB/$exe"

        sudo cp -a "$bundle/." "$HOST_LIB/$exe/"

        sudo ln -sf \
            "../lib/rx_package_manager/$exe/bin/$exe" \
            "$HOST_BIN/rxbuild"
    fi

    echo "✓ $exe"
    echo
done

echo "========================================="
echo " Done."
echo "========================================="