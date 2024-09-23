#!/bin/sh

#   -m 2048M \
qemu-system-x86_64 -cpu host -enable-kvm \
    -smp 2,cores=2 \
    -m 8096M \
    -net nic,model=virtio -net user,hostfwd=tcp::8222-:8222 \
    -display sdl \
    -drive format=raw,media=disk,if=ide,file=test_disk.img \
    -drive format=raw,media=disk,if=ide,file=dist/archlinux.squash \
    -kernel dist/vmlinuz-linux-zen \
    -append "root=/dev/sda1 SYSTEMD_SULOGIN_FORCE live livetestpath=/dev/sdb" \
    -initrd dist/initramfs-linux-zen.img
