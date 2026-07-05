echo "Download & Install Sqlite3"

[ -f "$LFS/tmp/sqlite3.tar.gz" ] || \
wget https://sqlite.org/2026/sqlite-autoconf-3530300.tar.gz \
     -O "$LFS/tmp/sqlite3.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/sqlite3.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-sqlite3.sh