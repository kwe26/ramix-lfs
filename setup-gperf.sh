echo "Download & Install gperf"

[ -f "$LFS/tmp/gperf.tar.gz" ] || \
wget https://ftp.gnu.org/pub/gnu/gperf/gperf-3.3.tar.gz \
     -O "$LFS/tmp/gperf.tar.gz"

cd $LFS/pkgs

tar -xf $LFS/tmp/gperf.tar.gz

sudo $LFS/invoke-chroot.sh $LFS/scripts_chroot/setup-gperf.sh