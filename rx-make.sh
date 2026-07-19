rxbuild   --root ./pkgs/bash-5.3   --manifest ./rxbuild/bash/manifest.toml   --build ./rxbuild/bash/build.toml   --output ./rxouts/bash
rxbuild   --root ./pkgs/linux-7.1.1  --manifest ./rxbuild/kernel-headers/manifest.toml   --build ./rxbuild/kernel-headers/build.toml   --output ./rxouts/kernel-headers
rxbuild   --root ./pkgs/glibc-2.43  --manifest ./rxbuild/glibc/manifest.toml   --build ./rxbuild/glibc/build.toml   --output ./rxouts/glibc
rxbuild   --root ./pkgs/ncurses-6.6  --manifest ./rxbuild/ncurses/manifest.toml   --build ./rxbuild/ncurses/build.toml   --output ./rxouts/ncurses
rxbuild   --root ./pkgs/readline-8.3  --manifest ./rxbuild/readline/manifest.toml   --build ./rxbuild/readline/build.toml   --output ./rxouts/readline
rxbuild   --root ./  --manifest ./rxbuild/ca_certs/manifest.toml   --build ./rxbuild/ca_certs/build.toml   --output ./rxouts/ca_certs
rxbuild   --root ./pkgs/zlib-1.3.2  --manifest ./rxbuild/zlib/manifest.toml   --build ./rxbuild/zlib/build.toml   --output ./rxouts/zlib
rxbuild   --root ./pkgs/openssl-3.5.7  --manifest ./rxbuild/openssl/manifest.toml   --build ./rxbuild/openssl/build.toml   --output ./rxouts/openssl