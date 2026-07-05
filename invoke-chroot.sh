#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# Ramix - Invoke Script Inside Chroot
###############################################################################

ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD="$ROOT/build"
PKGS="$ROOT/pkgs"

HOST_SCRIPT="$(realpath "$1")"
shift

if [[ ! -f "$HOST_SCRIPT" ]]; then
    echo "Script not found:"
    echo "    $HOST_SCRIPT"
    exit 1
fi

SCRIPT_NAME="$(basename "$HOST_SCRIPT")"

cleanup() {
    echo
    echo "Cleaning up mounts..."

    umount -lf "$BUILD/pkgs" 2>/dev/null || true
    umount -lf "$BUILD/tmp" 2>/dev/null || true
    umount -lf "$BUILD/run" 2>/dev/null || true
    umount -lf "$BUILD/proc" 2>/dev/null || true
    umount -lf "$BUILD/sys" 2>/dev/null || true
    umount -R "$BUILD/dev" 2>/dev/null || true

    rm -f "$BUILD/pkgs/$SCRIPT_NAME" 2>/dev/null || true
}

trap cleanup EXIT

echo "Preparing Ramix chroot..."

mkdir -p \
    "$BUILD/dev" \
    "$BUILD/proc" \
    "$BUILD/sys" \
    "$BUILD/run" \
    "$BUILD/tmp" \
    "$BUILD/pkgs"

mount --rbind /dev "$BUILD/dev"
mount --make-rslave "$BUILD/dev"

mount -t proc proc "$BUILD/proc"
mount -t sysfs sysfs "$BUILD/sys"

mount -t tmpfs \
    -o mode=1777,size=4G \
    tmpfs "$BUILD/tmp"

mount -t tmpfs tmpfs "$BUILD/run"

mount --bind "$PKGS" "$BUILD/pkgs"

cp "$HOST_SCRIPT" "$BUILD/pkgs/$SCRIPT_NAME"
chmod +x "$BUILD/pkgs/$SCRIPT_NAME"

echo
echo "Executing $SCRIPT_NAME inside Ramix..."
echo

chroot "$BUILD" /usr/bin/env -i \
    HOME=/root \
    TERM="${TERM:-linux}" \
    PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin \
    MAKEFLAGS="-j$(nproc)" \
    TESTSUITEFLAGS="-j$(nproc)" \
    /pkgs/"$SCRIPT_NAME" "$@"