echo "Download & Install Readline"

[ -f "$LFS/tmp/readline.tar.gz" ] || \
wget https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz \
     -O "$LFS/tmp/readline.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/readline.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-readline.sh