# archlinux

My build ArchLinux

## Build

./build.sh

# Update mirror list
reflector -p https | rankmirrors - -n 5 > test.txt