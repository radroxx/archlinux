#!/usr/bin/env -S -i sh

proot --kill-on-exit -r root --cwd=/ -0 \
    -b /dev -b /proc -b /sys -b /tmp \
    -b ./cache/build:/var/cache/build \
    -b ./cache/pacman:/var/cache/pacman \
    -b ./hooks:/var/cache/hooks \
    /bin/bash