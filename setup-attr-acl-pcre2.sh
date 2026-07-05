echo "Download & Install attr"

[ -f "$LFS/tmp/attr.tar.gz" ] || \
wget https://download.savannah.gnu.org/releases/attr/attr-2.5.2.tar.gz \
     -O "$LFS/tmp/attr.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/attr.tar.gz"

echo "Download & Install acl"

[ -f "$LFS/tmp/acl.tar.gz" ] || \
wget https://download.savannah.gnu.org/releases/acl/acl-2.3.2.tar.gz \
     -O "$LFS/tmp/acl.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/acl.tar.gz"


echo "Download & Install PCRE2"

[ -f "$LFS/tmp/pcre2.tar.gz" ] || \
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.46/pcre2-10.46.tar.gz \
     -O "$LFS/tmp/pcre2.tar.gz"

cd "$LFS/pkgs"

tar -xf "$LFS/tmp/pcre2.tar.gz"

sudo "$LFS/invoke-chroot.sh" \
     "$LFS/scripts_chroot/setup-aclattrpcre2.sh"
