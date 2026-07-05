echo "Download & Install GLib2"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/sync-pkgconf.sh"

[ -f "$LFS/tmp/glib.tar.xz" ] || \
wget https://download.gnome.org/sources/glib/2.86/glib-2.86.0.tar.xz \
     -O "$LFS/tmp/glib.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/glib.tar.xz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-glib2.sh"

     echo "Download & Install D-Bus"

[ -f "$LFS/tmp/dbus.tar.xz" ] || \
wget https://dbus.freedesktop.org/releases/dbus/dbus-1.16.2.tar.xz \
     -O "$LFS/tmp/dbus.tar.xz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/dbus.tar.xz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-dbus.sh"