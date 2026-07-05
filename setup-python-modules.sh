#!/usr/bin/env bash
set -euo pipefail

echo "Download & Install Python3 Modules"

mkdir -p "$LFS/tmp"

download() {
    local NAME="$1"
    local URL="$2"

    if [ ! -f "$LFS/tmp/$NAME.tar.gz" ]; then
        wget "$URL" -O "$LFS/tmp/$NAME.tar.gz"
    fi

    cd "$LFS/pkgs"
    tar -xf "$LFS/tmp/$NAME.tar.gz"
}

download MarkupSafe \
https://files.pythonhosted.org/packages/source/m/markupsafe/markupsafe-3.0.2.tar.gz

download Jinja2 \
https://files.pythonhosted.org/packages/source/j/jinja2/jinja2-3.1.6.tar.gz

download Packaging \
https://files.pythonhosted.org/packages/source/p/packaging/packaging-25.0.tar.gz

download PyYAML \
https://files.pythonhosted.org/packages/source/p/pyyaml/pyyaml-6.0.2.tar.gz

download Mako \
https://files.pythonhosted.org/packages/source/M/Mako/mako-1.3.10.tar.gz

wget https://files.pythonhosted.org/packages/source/f/flit_core/flit_core-3.12.0.tar.gz \
    -O "$LFS/tmp/flit_core.tar.gz"

cd "$LFS/pkgs"
tar -xf "$LFS/tmp/flit_core.tar.gz"

sudo "$LFS/invoke-chroot.sh" \
    "$LFS/scripts_chroot/setup-p3-modules.sh"