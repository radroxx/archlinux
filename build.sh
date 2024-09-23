#!/bin/sh

PROJECT_DIR=$(dirname $(readlink -f $0))
NEW_ROOT=/mnt/storage/builds/root
source ${PROJECT_DIR}/lib.sh

cat build_script.sh | $RUN /bin/sh

mkdir -p dist
mv ${NEW_ROOT}/boot/vmlinuz* dist/
mv ${NEW_ROOT}/boot/initramfs* dist/
mv ${NEW_ROOT}/boot/*-ucode.img dist/
mv ${NEW_ROOT}/boot/archlinux.squash dist/archlinux.squash

echo "You can delete root dir sudo rm -Rf ${NEW_ROOT}"
