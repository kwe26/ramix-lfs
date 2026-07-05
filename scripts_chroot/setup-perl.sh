cd /pkgs
cd perl-*

sh Configure \
    -des \
    -Dcc=gcc \
    -Dprefix=/usr \
    -Dvendorprefix=/usr \
    -Duseshrplib

make -j$(nproc)
make install

ldconfig

perl -e 'print "Perl works!\n";'