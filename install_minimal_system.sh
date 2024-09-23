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
echo "df1463dc3ede96f8f7663deaedd68b732fb5101d  /etc/ssl/certs/ca-certificates.crt" | /var/cache/build/busybox sha1sum -c -

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

[community]
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
93417254d9a6b8f9bcb9cab8843add0c86215547  /var/cache/pacman/pkg/archlinux-keyring-20240709-2-any.pkg.tar.zst
113d18081266a992184b49ccb1831e389daf3439  /var/cache/pacman/pkg/argon2-20190702-6-x86_64.pkg.tar.zst
f1a1ced932368f10f52a9c055da96b76160c7fb7  /var/cache/pacman/pkg/attr-2.5.2-1-x86_64.pkg.tar.zst
f499f76df6b05fe2d2895ec84216ae27ac5bfc67  /var/cache/pacman/pkg/audit-4.0.2-2-x86_64.pkg.tar.zst
d054de79bb540912f01854452861c5a462b6ee00  /var/cache/pacman/pkg/bash-5.2.032-2-x86_64.pkg.tar.zst
f7def46fdef10b7c4f61db47aee9d988d18473b7  /var/cache/pacman/pkg/brotli-1.1.0-2-x86_64.pkg.tar.zst
7620ef4baaeb93381d1f7edb2bdae98f400db659  /var/cache/pacman/pkg/bzip2-1.0.8-6-x86_64.pkg.tar.zst
d0b0279a51198be083f12cb4f525d9f6accf4d92  /var/cache/pacman/pkg/ca-certificates-20240618-1-any.pkg.tar.zst
1b1d679b177998efc480c4805a5de07e2aadf092  /var/cache/pacman/pkg/ca-certificates-mozilla-3.104-1-x86_64.pkg.tar.zst
4b2ba32651262e27137ac4aa45f18b7b9114fcf8  /var/cache/pacman/pkg/ca-certificates-utils-20240618-1-any.pkg.tar.zst
05864ea6bac04cd8dc08ff4a0b718b5c8914d3b2  /var/cache/pacman/pkg/coreutils-9.5-2-x86_64.pkg.tar.zst
879d98e40d2bbde5e703e232628c3a97da260938  /var/cache/pacman/pkg/cryptsetup-2.7.5-1-x86_64.pkg.tar.zst
48254ed2f41994fa2d80854ae9413b3f6b16271e  /var/cache/pacman/pkg/curl-8.10.1-1-x86_64.pkg.tar.zst
7d4c65f65cc32429c47c8c4d327d1213a5ef38a8  /var/cache/pacman/pkg/dbus-1.14.10-2-x86_64.pkg.tar.zst
6b87d11de2aadf773a45028fedddc3d46ef2d1ac  /var/cache/pacman/pkg/dbus-broker-36-4-x86_64.pkg.tar.zst
7d2d176d5acd21650f9344d20766af29df7da888  /var/cache/pacman/pkg/dbus-broker-units-36-4-x86_64.pkg.tar.zst
f7ae79c91ed114f5c3a3eacb4e93a1e44f7ab274  /var/cache/pacman/pkg/dbus-units-36-4-x86_64.pkg.tar.zst
a9a3659f9b1e59ea4293d7d2c577776dd9a29911  /var/cache/pacman/pkg/device-mapper-2.03.26-1-x86_64.pkg.tar.zst
b09eeb17fb56290e347853e61e8f6e538b6042bd  /var/cache/pacman/pkg/e2fsprogs-1.47.1-4-x86_64.pkg.tar.zst
2c4f799f4d11500bf7feb82240b23c18a7d9ee6c  /var/cache/pacman/pkg/expat-2.6.3-2-x86_64.pkg.tar.zst
1e32a788760a9b073fa31b565c0adec0b1494201  /var/cache/pacman/pkg/file-5.45-1-x86_64.pkg.tar.zst
4fe20443b1dab76938bfc62481d6beeb0fc7372e  /var/cache/pacman/pkg/filesystem-2024.04.07-1-any.pkg.tar.zst
50037a339b1deddaf831ca8c9a070acdbeef61f1  /var/cache/pacman/pkg/findutils-4.10.0-2-x86_64.pkg.tar.zst
23ac5f5177c7d6bdeef0c21c1717c2bc988243ed  /var/cache/pacman/pkg/gawk-5.3.1-1-x86_64.pkg.tar.zst
a71af21211ed8a0f3f7abe76af74a197532e7ad1  /var/cache/pacman/pkg/gcc-libs-14.2.1+r134+gab884fffe3fc-1-x86_64.pkg.tar.zst
c28a2b0424af6dedf81fab49daa2cc82dcb42199  /var/cache/pacman/pkg/gdbm-1.24-1-x86_64.pkg.tar.zst
d605c8e174e3caa4bc61873545bd41572f81f36f  /var/cache/pacman/pkg/gettext-0.22.5-2-x86_64.pkg.tar.zst
09baff9fac4a9141257a0d5117f7a6133fdb93c3  /var/cache/pacman/pkg/glib2-2.82.1-1-x86_64.pkg.tar.zst
19207780a3bd7fa3c297d7e625e7942d09ae29ce  /var/cache/pacman/pkg/glibc-2.40+r16+gaa533d58ff-2-x86_64.pkg.tar.zst
db304bc87abdb76d023221aefe5cf1911f49ea39  /var/cache/pacman/pkg/gmp-6.3.0-2-x86_64.pkg.tar.zst
0995a041793963d4dbc353e35d93271e7ab31c59  /var/cache/pacman/pkg/gnupg-2.4.5-5-x86_64.pkg.tar.zst
387d0c77f38285835c417d8eb8167cafe5eb8de2  /var/cache/pacman/pkg/gnutls-3.8.7-1-x86_64.pkg.tar.zst
8d45ee617306bc3f76c82e42c925795dc39f9c87  /var/cache/pacman/pkg/gpgme-1.23.2-6-x86_64.pkg.tar.zst
1f21033bf9c90dc3d8658c9f4c0965e20c3e9cca  /var/cache/pacman/pkg/grep-3.11-1-x86_64.pkg.tar.zst
3f77c3cfcc7faf48ce781014ba76b6539f13d573  /var/cache/pacman/pkg/gzip-1.13-4-x86_64.pkg.tar.zst
317af5a07da3de82d166f3a611a761a954a27496  /var/cache/pacman/pkg/hwdata-0.387-1-any.pkg.tar.zst
0e66bcd30778224d7aa74e5a20ce71bc535bf26f  /var/cache/pacman/pkg/iana-etc-20240814-1-any.pkg.tar.zst
54007775f2118e05f4508bc4ce73299ad49e209e  /var/cache/pacman/pkg/icu-75.1-1-x86_64.pkg.tar.zst
b5c37fe520158cf15bf6800699dd45a917a32962  /var/cache/pacman/pkg/json-c-0.18-1-x86_64.pkg.tar.zst
77f7361cd91903d1a686323c04e4e253ad567cae  /var/cache/pacman/pkg/kbd-2.6.4-3-x86_64.pkg.tar.zst
240513cc1462940d9f086f41a1b33a309dc99fcc  /var/cache/pacman/pkg/keyutils-1.6.3-3-x86_64.pkg.tar.zst
c3f7d847f6a9576ac6dfdd9bbe9c84f2b708e7a4  /var/cache/pacman/pkg/kmod-33-3-x86_64.pkg.tar.zst
52b79e2a208f68e6122c9ed284529f5a01e8cc80  /var/cache/pacman/pkg/krb5-1.21.3-1-x86_64.pkg.tar.zst
6cc1ca5613f3aa83d83ddc252b1f473834fc6faa  /var/cache/pacman/pkg/libarchive-3.7.5-1-x86_64.pkg.tar.zst
a02d92e048f94577dfa6a85fec960584f1190a18  /var/cache/pacman/pkg/libassuan-3.0.0-1-x86_64.pkg.tar.zst
e174e934ff5a8065a03a0d1dba2a4da40fd0729a  /var/cache/pacman/pkg/libcap-2.70-1-x86_64.pkg.tar.zst
5b6174715691763e3424c06d515054711251cbcf  /var/cache/pacman/pkg/libcap-ng-0.8.5-2-x86_64.pkg.tar.zst
21a27854806f38cc0d4f297107d71d39b0d23975  /var/cache/pacman/pkg/libelf-0.191-4-x86_64.pkg.tar.zst
0d8254af837f89be7fc0c18b7e0352f997d1537b  /var/cache/pacman/pkg/libevent-2.1.12-4-x86_64.pkg.tar.zst
56a2bc6ffc82825c816bdae153edc9ca8c90927d  /var/cache/pacman/pkg/libffi-3.4.6-1-x86_64.pkg.tar.zst
286149fe2d47938e737c5334863c18f85c288f15  /var/cache/pacman/pkg/libgcrypt-1.11.0-2-x86_64.pkg.tar.zst
184c16e600f31033d1ee9c7db0b5181c669ad993  /var/cache/pacman/pkg/libgpg-error-1.50-1-x86_64.pkg.tar.zst
e6331470d4d08fdf358d91594eaddf8f4fe5fcca  /var/cache/pacman/pkg/libidn2-2.3.7-1-x86_64.pkg.tar.zst
4eb3932e96c6a8eaaaf455b435ff93e7f6d78edb  /var/cache/pacman/pkg/libksba-1.6.7-1-x86_64.pkg.tar.zst
352d60a0293dce26f7033d24dfe7b636ed682199  /var/cache/pacman/pkg/libldap-2.6.8-2-x86_64.pkg.tar.zst
4cbe9cf358934814d4272b6effbaddec478b7230  /var/cache/pacman/pkg/libnghttp2-1.63.0-1-x86_64.pkg.tar.zst
adb578148606023ad99631f87781fdd117cc9815  /var/cache/pacman/pkg/libnghttp3-1.5.0-1-x86_64.pkg.tar.zst
f4fe162f97506dd550b19ef7c239439602069c6d  /var/cache/pacman/pkg/libnsl-2.0.1-1-x86_64.pkg.tar.zst
4da901fbcd2eb03819be1f3acfeb58dc661c6898  /var/cache/pacman/pkg/libp11-kit-0.25.5-1-x86_64.pkg.tar.zst
588807145a8a1bbf6168721fc1de172f8ee3c284  /var/cache/pacman/pkg/libpsl-0.21.5-2-x86_64.pkg.tar.zst
7e7aaecfcfac827b6167701d13e0aa4cc378a02c  /var/cache/pacman/pkg/libsasl-2.1.28-5-x86_64.pkg.tar.zst
15f3f99dff666263aa55fa914e7070b9874a0e82  /var/cache/pacman/pkg/libseccomp-2.5.5-3-x86_64.pkg.tar.zst
4a0bb282041e59fdc6a2f981d33d919fe747d4d1  /var/cache/pacman/pkg/libsecret-0.21.4-1-x86_64.pkg.tar.zst
91675cc51c466b8a49727f3e54dea918e8307458  /var/cache/pacman/pkg/libssh2-1.11.0-1-x86_64.pkg.tar.zst
5ab7cec72f6a733a5e20c49f8be4046ce7cc8a95  /var/cache/pacman/pkg/libsysprof-capture-47.0-1-x86_64.pkg.tar.zst
9dfc8b73e524c967732a38b99bcec9f47f91e17c  /var/cache/pacman/pkg/libtasn1-4.19.0-2-x86_64.pkg.tar.zst
27628111e59d5580f5e93af613d44d7fa6b7682d  /var/cache/pacman/pkg/libtirpc-1.3.5-1-x86_64.pkg.tar.zst
151470ed3d71f027175bba06fb797d5817e9a47c  /var/cache/pacman/pkg/libunistring-1.2-1-x86_64.pkg.tar.zst
8996373033d9215baebfe06b24a29eade9d13ea1  /var/cache/pacman/pkg/libusb-1.0.27-1-x86_64.pkg.tar.zst
1682dee2b343d3845f6106a14d779e6f9181159c  /var/cache/pacman/pkg/libverto-0.3.2-5-x86_64.pkg.tar.zst
032fece1e5067751dfe0bba3162490210e9ffcf3  /var/cache/pacman/pkg/libxcrypt-4.4.36-2-x86_64.pkg.tar.zst
883167ab47537fdba8673025f7a8f6e24b9f91d7  /var/cache/pacman/pkg/libxml2-2.13.4-1-x86_64.pkg.tar.zst
65aa13fb63ee2e2c58233c576c4aab5d379acf28  /var/cache/pacman/pkg/linux-api-headers-6.10-1-x86_64.pkg.tar.zst
d0296aec31be5b1e61714b5faf24c067dd6135dc  /var/cache/pacman/pkg/lmdb-0.9.33-1-x86_64.pkg.tar.zst
0c14357b1ad09cd8b2ed37c489f26f12b96e94da  /var/cache/pacman/pkg/lz4-1:1.10.0-2-x86_64.pkg.tar.zst
96eebc9d85cc23f52c32558361a8db41b5b89f02  /var/cache/pacman/pkg/mpfr-4.2.1-4-x86_64.pkg.tar.zst
5428d5fe7b7c162c158586d9167f997eae66cef1  /var/cache/pacman/pkg/ncurses-6.5-3-x86_64.pkg.tar.zst
6bc9799b2ff05ed33aa43feba09f2cb9dc05d6fb  /var/cache/pacman/pkg/nettle-3.10-1-x86_64.pkg.tar.zst
01fde302a3141b81e23c1e874fe0d4fb83b0eb6e  /var/cache/pacman/pkg/npth-1.7-1-x86_64.pkg.tar.zst
4eba827361c4598410ebfe19363efe9e372b5f98  /var/cache/pacman/pkg/openssl-3.3.2-1-x86_64.pkg.tar.zst
f908ffa2f678629d31c0af2a6b4bb985787855dd  /var/cache/pacman/pkg/p11-kit-0.25.5-1-x86_64.pkg.tar.zst
ee3742c1e71991a435c7e038f4101c84c0f7404e  /var/cache/pacman/pkg/pacman-7.0.0.r3.g7736133-1-x86_64.pkg.tar.zst
274a8dd1ebcaaf0904381d3410ce594ee79fb95d  /var/cache/pacman/pkg/pacman-mirrorlist-20240717-1-any.pkg.tar.zst
68c8f2b056220538deddf20a303042f4289bb0a6  /var/cache/pacman/pkg/pam-1.6.1-3-x86_64.pkg.tar.zst
89cdc9cc63baa3a621f4abe11f0510165b243b62  /var/cache/pacman/pkg/pambase-20230918-2-any.pkg.tar.zst
77c8aae7751f3a9728898a8e48616c54766ebe23  /var/cache/pacman/pkg/pcre2-10.44-1-x86_64.pkg.tar.zst
28a4ca42a43a786dc32ca921ea384beaa9f85386  /var/cache/pacman/pkg/pinentry-1.3.1-5-x86_64.pkg.tar.zst
25f81bf1bb7092bbc7271890c6675e44d2850330  /var/cache/pacman/pkg/popt-1.19-2-x86_64.pkg.tar.zst
17e838945c4c73689b9cc2f99baf32d80d3da6da  /var/cache/pacman/pkg/readline-8.2.013-1-x86_64.pkg.tar.zst
da9f37d49ce6b7b414495962b35f8f8c491ff5ef  /var/cache/pacman/pkg/sed-4.9-3-x86_64.pkg.tar.zst
7f4ac835fa473b16dc3cbbfefec400b89e183fa8  /var/cache/pacman/pkg/shadow-4.16.0-1-x86_64.pkg.tar.zst
9f76e99294fde7323e145584eda834307aa43426  /var/cache/pacman/pkg/sqlite-3.46.1-1-x86_64.pkg.tar.zst
f21c001046558eafb139cbe73e945405d193aa48  /var/cache/pacman/pkg/systemd-256.6-1-x86_64.pkg.tar.zst
99d4fc75644daa2d7d6d225a20cc99f5d323cff1  /var/cache/pacman/pkg/systemd-libs-256.6-1-x86_64.pkg.tar.zst
85cab3a6104669c9ffe6149422fcb4fc38179abc  /var/cache/pacman/pkg/tpm2-tss-4.0.1-1-x86_64.pkg.tar.zst
27c42adce89b1b1b5da66fdc63a3aee36aabe564  /var/cache/pacman/pkg/tzdata-2024b-2-x86_64.pkg.tar.zst
295165ffd56a9986e4bbaffea0de0a27ba2ef29b  /var/cache/pacman/pkg/util-linux-2.40.2-1-x86_64.pkg.tar.zst
12cb41aa85bfbd54c1a41a2103f47b893175541e  /var/cache/pacman/pkg/util-linux-libs-2.40.2-1-x86_64.pkg.tar.zst
2636dbf555caf5528a82add6653df325f9a5966e  /var/cache/pacman/pkg/xz-5.6.2-1-x86_64.pkg.tar.zst
8a0bf9ab5cb07b27386d11410fe320f38103806a  /var/cache/pacman/pkg/zlib-1:1.3.1-2-x86_64.pkg.tar.zst
4f6d0ea79e70a06cff5974c2ba5d1c63f0d50ac8  /var/cache/pacman/pkg/zstd-1.5.6-1-x86_64.pkg.tar.zst
EOF

# install pkgs
/var/cache/build/pacman --sync --noconfirm archlinux-keyring

test -f /etc/pacman.conf.pacnew && /var/cache/build/busybox mv /etc/pacman.conf.pacnew /etc/pacman.conf
test -f /etc/resolv.conf.pacnew && /var/cache/build/busybox rm /etc/resolv.conf.pacnew
test -f /etc/pacman.d/mirrorlist.pacnew && /var/cache/build/busybox rm /etc/pacman.d/mirrorlist.pacnew

/usr/bin/locale-gen
/usr/bin/pacman-key --init
/usr/bin/pacman-key --populate archlinux
