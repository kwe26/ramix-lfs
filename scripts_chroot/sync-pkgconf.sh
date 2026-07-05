mkdir -p /usr/lib/pkgconfig
mkdir -p /usr/lib64/pkgconfig

# Sync lib -> lib64
find /usr/lib/pkgconfig -type f -name '*.pc' | while read -r pc; do
    ln -sf "$pc" "/usr/lib64/pkgconfig/$(basename "$pc")"
done

# Sync lib64 -> lib
find /usr/lib64/pkgconfig -type f -name '*.pc' | while read -r pc; do
    ln -sf "$pc" "/usr/lib/pkgconfig/$(basename "$pc")"
done