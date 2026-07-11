#!/usr/bin/env bash
set -Eeuo pipefail

: "${DESTDIR:?DESTDIR not set}"

CERT_URL="https://curl.se/ca/cacert.pem"

echo "==> Installing CA Certificates"


install -d \
    "$DESTDIR/etc/ssl" \
    "$DESTDIR/etc/ssl/certs" \
    "$DESTDIR/usr/share/ca-certificates"

# Download latest Mozilla bundle
curl -L \
    --fail \
    --proto '=https' \
    --tlsv1.2 \
    -o "$DESTDIR/etc/ssl/certs/ca-certificates.crt" \
    "$CERT_URL"

ln -sf \
    certs/ca-certificates.crt \
    "$DESTDIR/etc/ssl/cert.pem"

mkdir -p "$DESTDIR/etc/pki/tls"
ln -sf \
    ../../ssl/certs \
    "$DESTDIR/etc/pki/tls/certs"

ln -sf \
    ../../ssl/cert.pem \
    "$DESTDIR/etc/pki/tls/cert.pem"

echo "==> Installed CA bundle"