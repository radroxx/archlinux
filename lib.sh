set -e

CACHE_DIR=/mnt/storage/builds/cache

mkdir -p ${NEW_ROOT}/var/cache/build/
mkdir -p ${CACHE_DIR}/{pacman,build}

# Download busybox
test -f ${CACHE_DIR}/build/busybox \
    || wget -O ${CACHE_DIR}/build/busybox https://www.busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox

# Download curl
test -f ${CACHE_DIR}/build/curl \
    || wget -O - https://github.com/stunnel/static-curl/releases/download/8.9.1/curl-linux-x86_64-8.9.1.tar.xz | tar -xJ -C ${CACHE_DIR}/build curl

chmod +x ${CACHE_DIR}/build/busybox
chmod +x ${CACHE_DIR}/build/curl

RUN="env -i HOME=/tmp/root PATH=/usr/local/sbin:/usr/local/bin:/usr/bin /usr/bin/proot --kill-on-exit --root-id --cwd=/ -r ${NEW_ROOT}"
RUN="$RUN -b /dev -b /sys -b /proc -b /tmp"
RUN="$RUN -b ${CACHE_DIR}/pacman:/var/cache/pacman"
RUN="$RUN -b ${CACHE_DIR}/build:/var/cache/build"
RUN="$RUN -b ${PROJECT_DIR}/hooks:/var/cache/hooks"

$RUN /var/cache/build/busybox mkdir -p /tmp/root

cat install_minimal_system.sh | $RUN /var/cache/build/busybox ash