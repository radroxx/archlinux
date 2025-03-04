#!/bin/sh

set -e

test -f /etc/issue && exit 0

# Config resolv.conf
/var/cache/build/busybox mkdir -p /etc
/var/cache/build/busybox echo "nameserver 1.1.1.1" > /etc/resolv.conf
/var/cache/build/busybox echo "nameserver 1.0.0.1" >> /etc/resolv.conf
/var/cache/build/busybox echo "nameserver 8.8.8.8" >> /etc/resolv.conf
/var/cache/build/busybox echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Download ca-cert
/var/cache/build/busybox mkdir -p /etc/ssl/certs
test -f /etc/ssl/certs/ca-certificates.crt || /var/cache/build/curl --insecure --output /etc/ssl/certs/ca-certificates.crt https://curl.se/ca/cacert.pem
echo "19820cf6648bed32b56ece4f8d8ab5e50919defe  /etc/ssl/certs/ca-certificates.crt" | /var/cache/build/busybox sha1sum -c -

# Download pacman-static
test -f /var/cache/build/pacman || /var/cache/build/curl --output /var/cache/build/pacman https://pkgbuild.com/~morganamilo/pacman-static/x86_64/bin/pacman-static
/var/cache/build/busybox chmod +x /var/cache/build/pacman

# config pacman
/var/cache/build/busybox mkdir -p /var/lib/pacman/
/var/cache/build/busybox mkdir -p /etc/pacman.d
/var/cache/build/busybox cat <<EOF > /etc/pacman.conf
[options]
ParallelDownloads = 5
Architecture = auto

SigLevel = Never

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF

/var/cache/build/busybox cat <<EOF > /etc/pacman.d/mirrorlist
Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://mirror.leaseweb.net/archlinux/\$repo/os/\$arch
EOF

# hack disabled hook
/var/cache/build/busybox mkdir -p /etc/pacman.d/hooks
/var/cache/build/busybox cat <<EOF > /etc/pacman.d/hooks/30-systemd-tmpfiles.hook
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Target = usr/lib/tmpfiles.d/*.conf

[Action]
Description = Creating temporary files...
When = PostTransaction
Exec = /usr/bin/true
EOF

# Download pkgs
/var/cache/build/pacman --sync --noconfirm --refresh --downloadonly archlinux-keyring
/var/cache/build/busybox rm /etc/ssl/certs/ca-certificates.crt

# pacman --sync --noconfirm --refresh --downloadonly --root empty --cachedir cache archlinux-keyring
# sha1sum pkg/*.zst | sed 's#  pkg/#  /var/cache/pacman/pkg/#g' | clipcopy
/var/cache/build/busybox cat <<EOF | /var/cache/build/busybox sha1sum -c -
10846bd38b701409674c6deefed8aedbbb58d511  /var/cache/pacman/pkg/acl-2.3.2-1-x86_64.pkg.tar.zst
5c226b8c8dc6306b5c23107f573bf10099c9e3df  /var/cache/pacman/pkg/archlinux-keyring-20250123-1-any.pkg.tar.zst
f1a1ced932368f10f52a9c055da96b76160c7fb7  /var/cache/pacman/pkg/attr-2.5.2-1-x86_64.pkg.tar.zst
43e32b146c2b5b32e1e7d19e84d1dafdf7634a84  /var/cache/pacman/pkg/audit-4.0.3-1-x86_64.pkg.tar.zst
a629fbf61d28ca4eff94e097f408f70bd4cff208  /var/cache/pacman/pkg/bash-5.2.037-1-x86_64.pkg.tar.zst
e787338e639a47fcdea787658c9d59b2d88a1b5f  /var/cache/pacman/pkg/brotli-1.1.0-3-x86_64.pkg.tar.zst
7620ef4baaeb93381d1f7edb2bdae98f400db659  /var/cache/pacman/pkg/bzip2-1.0.8-6-x86_64.pkg.tar.zst
d0b0279a51198be083f12cb4f525d9f6accf4d92  /var/cache/pacman/pkg/ca-certificates-20240618-1-any.pkg.tar.zst
7eee1b9f764ed043696f7aab047593f17c0afefe  /var/cache/pacman/pkg/ca-certificates-mozilla-3.109-1-x86_64.pkg.tar.zst
4b2ba32651262e27137ac4aa45f18b7b9114fcf8  /var/cache/pacman/pkg/ca-certificates-utils-20240618-1-any.pkg.tar.zst
2f5748ccdb2b2a034587fffb087479dd4328831c  /var/cache/pacman/pkg/coreutils-9.6-3-x86_64.pkg.tar.zst
c2fd9e8431abc59fac7b91fd6144445300518880  /var/cache/pacman/pkg/cryptsetup-2.7.5-2-x86_64.pkg.tar.zst
a0e30e23a91cdcdfcff9992877d5799790730b2d  /var/cache/pacman/pkg/curl-8.12.1-1-x86_64.pkg.tar.zst
49df354f23cf990189dd8000d0083d21d67b9c4d  /var/cache/pacman/pkg/dbus-1.16.2-1-x86_64.pkg.tar.zst
6b87d11de2aadf773a45028fedddc3d46ef2d1ac  /var/cache/pacman/pkg/dbus-broker-36-4-x86_64.pkg.tar.zst
7d2d176d5acd21650f9344d20766af29df7da888  /var/cache/pacman/pkg/dbus-broker-units-36-4-x86_64.pkg.tar.zst
f7ae79c91ed114f5c3a3eacb4e93a1e44f7ab274  /var/cache/pacman/pkg/dbus-units-36-4-x86_64.pkg.tar.zst
0919bc2ebe441305f4d87a11734f489ca1128c90  /var/cache/pacman/pkg/device-mapper-2.03.31-1-x86_64.pkg.tar.zst
449068054769dcecb68fdb1fe51683e3ca2ce95f  /var/cache/pacman/pkg/e2fsprogs-1.47.2-1-x86_64.pkg.tar.zst
1be5cf5f4c63b9eece4c23f1b61564d877233771  /var/cache/pacman/pkg/expat-2.6.4-1-x86_64.pkg.tar.zst
3fb4f3493b7a83e3d6f6aa2a400ef736bac5a698  /var/cache/pacman/pkg/file-5.46-3-x86_64.pkg.tar.zst
72671606b2d74600269a506ff5a3953dc43ba3df  /var/cache/pacman/pkg/filesystem-2024.11.21-1-any.pkg.tar.zst
50037a339b1deddaf831ca8c9a070acdbeef61f1  /var/cache/pacman/pkg/findutils-4.10.0-2-x86_64.pkg.tar.zst
23ac5f5177c7d6bdeef0c21c1717c2bc988243ed  /var/cache/pacman/pkg/gawk-5.3.1-1-x86_64.pkg.tar.zst
0da91580d1721888c5928dc2ec8ef13b65880d8e  /var/cache/pacman/pkg/gcc-libs-14.2.1+r753+g1cd744a6828f-1-x86_64.pkg.tar.zst
6ba3aba3cf220af2acb393364c95afab4eb34830  /var/cache/pacman/pkg/gdbm-1.24-2-x86_64.pkg.tar.zst
1783c44538f68bf209ae54a479c4d4a8ac6d6040  /var/cache/pacman/pkg/gettext-0.24-1-x86_64.pkg.tar.zst
0614e75ce790fec07105d298c55011f9c0a980c4  /var/cache/pacman/pkg/glib2-2.82.5-1-x86_64.pkg.tar.zst
9b3759ca3a356bcfa8ae382f544f987d6cb4d420  /var/cache/pacman/pkg/glibc-2.41+r9+ga900dbaf70f0-1-x86_64.pkg.tar.zst
db304bc87abdb76d023221aefe5cf1911f49ea39  /var/cache/pacman/pkg/gmp-6.3.0-2-x86_64.pkg.tar.zst
0914ccabf25c01f520adc7cb7640f928bca5e634  /var/cache/pacman/pkg/gnulib-l10n-20241231-1-any.pkg.tar.zst
7fe3bf49b67376a37ba6a4287e7a21a27bc91fb4  /var/cache/pacman/pkg/gnupg-2.4.7-1-x86_64.pkg.tar.zst
036dfe695824d2a71d858dceb53d1a0b7898aa7a  /var/cache/pacman/pkg/gnutls-3.8.9-1-x86_64.pkg.tar.zst
a7bfa5716642fa5bb6f4d603b49ed9a42b98b60a  /var/cache/pacman/pkg/gpgme-1.24.2-1-x86_64.pkg.tar.zst
1f21033bf9c90dc3d8658c9f4c0965e20c3e9cca  /var/cache/pacman/pkg/grep-3.11-1-x86_64.pkg.tar.zst
3f77c3cfcc7faf48ce781014ba76b6539f13d573  /var/cache/pacman/pkg/gzip-1.13-4-x86_64.pkg.tar.zst
57cb77bd1d723265228c885ea49df8ddaa214c09  /var/cache/pacman/pkg/hwdata-0.392-1-any.pkg.tar.zst
dbb60409c7c73781295457a7c6d847443a2a0583  /var/cache/pacman/pkg/iana-etc-20250213-1-any.pkg.tar.zst
312ca6b85598cf0e75b812aeb1411cec9e327a74  /var/cache/pacman/pkg/icu-76.1-1-x86_64.pkg.tar.zst
b5c37fe520158cf15bf6800699dd45a917a32962  /var/cache/pacman/pkg/json-c-0.18-1-x86_64.pkg.tar.zst
07ec34d66d94d84092c6f2535bacdf338bd11a45  /var/cache/pacman/pkg/kbd-2.7.1-2-x86_64.pkg.tar.zst
240513cc1462940d9f086f41a1b33a309dc99fcc  /var/cache/pacman/pkg/keyutils-1.6.3-3-x86_64.pkg.tar.zst
ef7a917b535015929c2a19b37dca741e16f4c7b8  /var/cache/pacman/pkg/kmod-34-1-x86_64.pkg.tar.zst
52b79e2a208f68e6122c9ed284529f5a01e8cc80  /var/cache/pacman/pkg/krb5-1.21.3-1-x86_64.pkg.tar.zst
c1dde4f6caf9d451ad0cf7b46d6d1630fc87c769  /var/cache/pacman/pkg/leancrypto-1.2.0-2-x86_64.pkg.tar.zst
6087e648124f890561a5a83cbfe2568dd3cc9393  /var/cache/pacman/pkg/libarchive-3.7.7-1-x86_64.pkg.tar.zst
a02d92e048f94577dfa6a85fec960584f1190a18  /var/cache/pacman/pkg/libassuan-3.0.0-1-x86_64.pkg.tar.zst
7d2bef72ca05189558fbc5a29d4baee65477f326  /var/cache/pacman/pkg/libcap-2.71-1-x86_64.pkg.tar.zst
f1860450a2586b15d9d034bfa3b078b8a034c46c  /var/cache/pacman/pkg/libcap-ng-0.8.5-3-x86_64.pkg.tar.zst
fa240a968b992e55f5cf8c5466f21b923efebeba  /var/cache/pacman/pkg/libelf-0.192-4-x86_64.pkg.tar.zst
0d8254af837f89be7fc0c18b7e0352f997d1537b  /var/cache/pacman/pkg/libevent-2.1.12-4-x86_64.pkg.tar.zst
b745f7ce3c3d28587c7e600127b8b9cac6b1154c  /var/cache/pacman/pkg/libffi-3.4.7-1-x86_64.pkg.tar.zst
02e6496d04f55106e92dd0d538f05402937ce8c6  /var/cache/pacman/pkg/libgcrypt-1.11.0-3-x86_64.pkg.tar.zst
5d33dc504f0d7d4c9ae7b06dc18709f3f2b47c84  /var/cache/pacman/pkg/libgpg-error-1.51-1-x86_64.pkg.tar.zst
e6331470d4d08fdf358d91594eaddf8f4fe5fcca  /var/cache/pacman/pkg/libidn2-2.3.7-1-x86_64.pkg.tar.zst
4eb3932e96c6a8eaaaf455b435ff93e7f6d78edb  /var/cache/pacman/pkg/libksba-1.6.7-1-x86_64.pkg.tar.zst
8174fc28a587ff1aacbc38031386d36475255db5  /var/cache/pacman/pkg/libldap-2.6.9-1-x86_64.pkg.tar.zst
ca59c173b0d9d27609a3a6b2dce7c9d1406b81db  /var/cache/pacman/pkg/libnghttp2-1.65.0-1-x86_64.pkg.tar.zst
56498fec3db0e749575ea82c7d30af820aaa6ea2  /var/cache/pacman/pkg/libnghttp3-1.8.0-1-x86_64.pkg.tar.zst
f4fe162f97506dd550b19ef7c239439602069c6d  /var/cache/pacman/pkg/libnsl-2.0.1-1-x86_64.pkg.tar.zst
4da901fbcd2eb03819be1f3acfeb58dc661c6898  /var/cache/pacman/pkg/libp11-kit-0.25.5-1-x86_64.pkg.tar.zst
588807145a8a1bbf6168721fc1de172f8ee3c284  /var/cache/pacman/pkg/libpsl-0.21.5-2-x86_64.pkg.tar.zst
7e7aaecfcfac827b6167701d13e0aa4cc378a02c  /var/cache/pacman/pkg/libsasl-2.1.28-5-x86_64.pkg.tar.zst
378828c9d036d9b2fad2e352db12325ec2b86ce2  /var/cache/pacman/pkg/libseccomp-2.5.5-4-x86_64.pkg.tar.zst
bf441d61226b1334efd9bc9804f7251ff93b95a1  /var/cache/pacman/pkg/libsecret-0.21.6-1-x86_64.pkg.tar.zst
e52b17636602f0fcefaceb4cd1b77641483b406e  /var/cache/pacman/pkg/libssh2-1.11.1-1-x86_64.pkg.tar.zst
fe85f6cd0368e448efb711ef5e745beeebe35490  /var/cache/pacman/pkg/libsysprof-capture-47.2-3-x86_64.pkg.tar.zst
e1e52cadee10bd8ae431f2cd9c90befdd34e5937  /var/cache/pacman/pkg/libtasn1-4.20.0-1-x86_64.pkg.tar.zst
7a94868ca4698f39cf909bf14932d3e6b3ecd513  /var/cache/pacman/pkg/libtirpc-1.3.6-1-x86_64.pkg.tar.zst
dd72b71b6a2ea8d2ed27e0d06f9804d37a96a1c4  /var/cache/pacman/pkg/libunistring-1.3-1-x86_64.pkg.tar.zst
8996373033d9215baebfe06b24a29eade9d13ea1  /var/cache/pacman/pkg/libusb-1.0.27-1-x86_64.pkg.tar.zst
1682dee2b343d3845f6106a14d779e6f9181159c  /var/cache/pacman/pkg/libverto-0.3.2-5-x86_64.pkg.tar.zst
6af9962648043a5ccd6b2804f7e9c61fbb543dcc  /var/cache/pacman/pkg/libxcrypt-4.4.38-1-x86_64.pkg.tar.zst
a09e17aa3d3f607034a8bded74d222783901181c  /var/cache/pacman/pkg/libxml2-2.13.6-3-x86_64.pkg.tar.zst
93af6039c916e6060d55518a17cdce16bab14a2d  /var/cache/pacman/pkg/linux-api-headers-6.13-1-x86_64.pkg.tar.zst
d0296aec31be5b1e61714b5faf24c067dd6135dc  /var/cache/pacman/pkg/lmdb-0.9.33-1-x86_64.pkg.tar.zst
0c14357b1ad09cd8b2ed37c489f26f12b96e94da  /var/cache/pacman/pkg/lz4-1:1.10.0-2-x86_64.pkg.tar.zst
dbceeebd8e245d06dd20aaeb0b02b446f71d7c7b  /var/cache/pacman/pkg/mpfr-4.2.1-6-x86_64.pkg.tar.zst
5428d5fe7b7c162c158586d9167f997eae66cef1  /var/cache/pacman/pkg/ncurses-6.5-3-x86_64.pkg.tar.zst
82ddf75566054b78d27a1159da6b91962046a6b3  /var/cache/pacman/pkg/nettle-3.10.1-1-x86_64.pkg.tar.zst
17bc4703562315cfd12c959d88e89cfc4982417e  /var/cache/pacman/pkg/npth-1.8-1-x86_64.pkg.tar.zst
4fb2dd982c1fe2afd22234f6f942f1367710bb92  /var/cache/pacman/pkg/openssl-3.4.1-1-x86_64.pkg.tar.zst
f908ffa2f678629d31c0af2a6b4bb985787855dd  /var/cache/pacman/pkg/p11-kit-0.25.5-1-x86_64.pkg.tar.zst
8ad1bd2bd84055f9c27728088f6cbc95281d6cc5  /var/cache/pacman/pkg/pacman-7.0.0.r6.gc685ae6-2-x86_64.pkg.tar.zst
f5872196d0fe3d06335e998c38bc8d314faecc30  /var/cache/pacman/pkg/pacman-mirrorlist-20250101-1-any.pkg.tar.zst
d8c53083edd762c7653f82e80b488c24b4a97311  /var/cache/pacman/pkg/pam-1.7.0-2-x86_64.pkg.tar.zst
89cdc9cc63baa3a621f4abe11f0510165b243b62  /var/cache/pacman/pkg/pambase-20230918-2-any.pkg.tar.zst
20207b824cefe8c4602002cab5a2c1c18d8f14b7  /var/cache/pacman/pkg/pcre2-10.45-1-x86_64.pkg.tar.zst
28a4ca42a43a786dc32ca921ea384beaa9f85386  /var/cache/pacman/pkg/pinentry-1.3.1-5-x86_64.pkg.tar.zst
25f81bf1bb7092bbc7271890c6675e44d2850330  /var/cache/pacman/pkg/popt-1.19-2-x86_64.pkg.tar.zst
17e838945c4c73689b9cc2f99baf32d80d3da6da  /var/cache/pacman/pkg/readline-8.2.013-1-x86_64.pkg.tar.zst
da9f37d49ce6b7b414495962b35f8f8c491ff5ef  /var/cache/pacman/pkg/sed-4.9-3-x86_64.pkg.tar.zst
1159af47732d171564d3e4748375b66b9245bb5d  /var/cache/pacman/pkg/shadow-4.17.3-1-x86_64.pkg.tar.zst
88be509e317fd1e170f2639c7be444f819c259a3  /var/cache/pacman/pkg/sqlite-3.49.1-1-x86_64.pkg.tar.zst
15bf57412cd43073d6321b536c8e539bd8927c52  /var/cache/pacman/pkg/systemd-257.3-1-x86_64.pkg.tar.zst
f70e9a240f281f1c854d56689d1ec50fe5f15a14  /var/cache/pacman/pkg/systemd-libs-257.3-1-x86_64.pkg.tar.zst
94620c5f9e34917bccf05bb7db3dfff958774ed3  /var/cache/pacman/pkg/tpm2-tss-4.1.3-1-x86_64.pkg.tar.zst
dfd3fec8bba9d5fa4549053fc444644a0505d650  /var/cache/pacman/pkg/tzdata-2025a-1-x86_64.pkg.tar.zst
948a2f41c7b3a1ce0dfb9516ceb990ad597e2be8  /var/cache/pacman/pkg/util-linux-2.40.4-1-x86_64.pkg.tar.zst
60432c0d292f4af9b3841545a732e13c4e02678e  /var/cache/pacman/pkg/util-linux-libs-2.40.4-1-x86_64.pkg.tar.zst
4e7a2025468aa0fae3eec21fec906520cf46b572  /var/cache/pacman/pkg/xz-5.6.4-1-x86_64.pkg.tar.zst
8a0bf9ab5cb07b27386d11410fe320f38103806a  /var/cache/pacman/pkg/zlib-1:1.3.1-2-x86_64.pkg.tar.zst
aa90fccb5704e5a869e2349fb53078ac5ef38244  /var/cache/pacman/pkg/zstd-1.5.7-2-x86_64.pkg.tar.zst
EOF

# install pkgs
/var/cache/build/pacman --sync --noconfirm archlinux-keyring

test -f /etc/pacman.conf.pacnew && /var/cache/build/busybox mv /etc/pacman.conf.pacnew /etc/pacman.conf
test -f /etc/resolv.conf.pacnew && /var/cache/build/busybox rm /etc/resolv.conf.pacnew
test -f /etc/pacman.d/mirrorlist.pacnew && /var/cache/build/busybox rm /etc/pacman.d/mirrorlist.pacnew

/usr/bin/locale-gen
/usr/bin/pacman-key --init
/usr/bin/pacman-key --populate archlinux
