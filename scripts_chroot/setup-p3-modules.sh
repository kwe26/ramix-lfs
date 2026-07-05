#!/usr/bin/env bash
set -euo pipefail

cd /pkgs

install_python_module() {

    local DIR="$1"

    echo
    echo "Installing $DIR..."

    cd "/pkgs/$DIR"

    python3 -m pip install \
        . \
        --no-build-isolation \
        --no-cache-dir
}

install_python_module "markupsafe-3.0.2"

install_python_module "flit_core-3.12.0"

install_python_module "jinja2-3.1.6"

install_python_module "packaging-25.0"

install_python_module "pyyaml-6.0.2"

install_python_module "mako-1.3.10"

python3 - <<EOF
import jinja2
import markupsafe
import packaging
import yaml
import mako

print("===================================")
print("Python modules installed correctly")
print("===================================")

print("Jinja2     :", jinja2.__version__)
print("MarkupSafe :", markupsafe.__version__)
print("Packaging  :", packaging.__version__)
print("PyYAML     :", yaml.__version__)
print("Mako       :", mako.__version__)
EOF