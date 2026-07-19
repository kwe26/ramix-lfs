#!/usr/bin/env bash
set -Eeuo pipefail

: "${DESTDIR:?DESTDIR not set}"

CERT_URL="https://curl.se/ca/cacert.pem"

echo "==> Installing CA Certificates"

CERTDIR="$DESTDIR/usr/ssl/certs"

install -d \
    "$CERTDIR" \
    "$DESTDIR/usr/share/ca-certificates" \
    "$DESTDIR/etc/ssl"

# Download Mozilla bundle
curl -L \
    --fail \
    --proto '=https' \
    --tlsv1.2 \
    -o "$CERTDIR/ca-certificates.crt" \
    "$CERT_URL"

# Split bundle into individual PEM files
if command -v openssl >/dev/null 2>&1; then
    tmpdir="$(mktemp -d)"

    openssl crl2pkcs7 \
        -nocrl \
        -certfile "$CERTDIR/ca-certificates.crt" |
    openssl pkcs7 \
        -print_certs \
        -out "$tmpdir/all.pem"

    awk -v out="$CERTDIR/" '
    BEGIN {
        cert = ""
        n = 0
    }

    /^subject=/ || /^issuer=/ {
        next
    }

    /-----BEGIN CERTIFICATE-----/ {
        cert = ""
    }

    {
        cert = cert $0 "\n"
    }

    /-----END CERTIFICATE-----/ {
        n++
        file = sprintf("%scert-%03d.pem", out, n)
        print cert > file
        close(file)
    }
    ' "$tmpdir/all.pem"

    rm -rf "$tmpdir"

    # Generate *.0 hashed symlinks
    openssl rehash "$CERTDIR"
fi

# Canonical bundle path
ln -sfn certs/ca-certificates.crt \
    "$DESTDIR/usr/ssl/cert.pem"

# Compatibility links
ln -sfn ../../usr/ssl/certs \
    "$DESTDIR/etc/ssl/certs"

ln -sfn ../../usr/ssl/cert.pem \
    "$DESTDIR/etc/ssl/cert.pem"

echo "==> Installed CA bundle"