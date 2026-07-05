#!/bin/sh
# preflight.sh — run inside chroot as the final step before packaging.
# Exits non-zero if anything looks boot-breaking, so you can gate the
# squashfs build on this instead of finding out after a reboot.

FAIL=0
warn() { echo "[FAIL] $*"; FAIL=1; }
ok()   { echo "[ OK ] $*"; }

echo "== 1. systemd-analyze verify (catches missing ExecStart binaries, bad unit syntax) =="
if command -v systemd-analyze >/dev/null 2>&1; then
    systemd-analyze verify /usr/lib/systemd/system/*.service /etc/systemd/system/*.service 2>&1
else
    warn "systemd-analyze not built/installed — skipping the single most useful check"
fi

echo "== 2. ExecStart binaries for all shipped unit files actually exist and are executable =="
for unitfile in /usr/lib/systemd/system/*.service /etc/systemd/system/*.service; do
    [ -f "$unitfile" ] || continue
    grep -E '^ExecStart(Pre|Post)?=' "$unitfile" 2>/dev/null | sed -E 's/^ExecStart[A-Za-z]*=-?//' | awk '{print $1}' | while read -r bin; do
        [ -z "$bin" ] && continue
        case "$bin" in
            /*) path="$bin" ;;
            *)  path=$(command -v "$bin" 2>/dev/null) ;;
        esac
        if [ -z "$path" ] || [ ! -x "$path" ]; then
            warn "$unitfile references missing/non-executable: $bin"
        fi
    done
done
ok "unit ExecStart scan complete"

echo "== 3. Broken symlinks anywhere on the rootfs =="
find / -xdev -xtype l 2>/dev/null | while read -r l; do
    warn "broken symlink: $l -> $(readlink "$l")"
done

echo "== 4. Shared library resolution for every installed binary =="
for f in /usr/bin/* /usr/sbin/* /bin/* /sbin/*; do
    [ -f "$f" ] && [ -x "$f" ] || continue
    missing=$(ldd "$f" 2>/dev/null | grep "not found")
    [ -n "$missing" ] && warn "$f has unresolved libs: $(echo "$missing" | tr '\n' ';')"
done
ok "ldd scan complete"

echo "== 5. PAM stack completeness (includes + modules) =="
MODDIRS="/usr/lib/security /lib/security /usr/lib64/security"
for f in /etc/pam.d/*; do
    [ -f "$f" ] || continue
    awk '{for(i=1;i<=NF;i++) if($i=="include") print $(i+1)}' "$f" | while read -r inc; do
        [ -f "/etc/pam.d/$inc" ] || warn "$f includes missing file: $inc"
    done
    grep -oE 'pam_[a-zA-Z0-9_]+\.so' "$f" | sort -u | while read -r mod; do
        found=""
        for d in $MODDIRS; do [ -f "$d/$mod" ] && found=1; done
        [ -z "$found" ] && warn "$f references missing module: $mod"
    done
done
ok "PAM completeness scan complete"

echo "== 6. Account file consistency =="
command -v pwck >/dev/null 2>&1 && pwck -r /etc/passwd 2>&1 || warn "pwck not available"
command -v grpck >/dev/null 2>&1 && grpck -r /etc/group 2>&1 || warn "grpck not available"

echo "== 7. nsswitch.conf present (NSS lookups for getpwnam etc.) =="
if [ ! -f /etc/nsswitch.conf ]; then
    warn "/etc/nsswitch.conf missing"
else
    ok "/etc/nsswitch.conf present"
fi

echo "== 8. End-to-end login smoke test (the real test — exactly what boot will do) =="
RESULT=$(echo 'echo PAM_LOGIN_OK; exit' | login -f root 2>&1)
echo "$RESULT"
case "$RESULT" in
    *PAM_LOGIN_OK*) ok "login -f root succeeded end-to-end" ;;
    *) warn "login -f root did NOT reach a shell" ;;
esac

echo "=================================================="
if [ "$FAIL" -eq 1 ]; then
    echo "PREFLIGHT FAILED — do not package this rootfs yet."
    exit 1
else
    echo "PREFLIGHT PASSED."
    exit 0
fi