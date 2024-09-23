#!/bin/sh

PROJECT_DIR=$(dirname $(readlink -f $0))
NEW_ROOT=/mnt/storage/builds/aurroot
source ${PROJECT_DIR}/lib.sh

if [ -f ${NEW_ROOT}/usr/bin/git ]
then
    echo "Dev tools exists"
else
    $RUN /usr/bin/pacman --sync --noconfirm --noscriptlet devtools debugedit gzip make git clang base-devel
    $RUN /usr/bin/sed -i "s/EUID == 0/EUID == 1/g" /usr/bin/makepkg
    $RUN /usr/bin/git config --global init.defaultBranch master
fi

cat <<EOF | tr "@" "$" | $RUN /usr/bin/sh

mkdir @{HOME}
cd @{HOME}

function build()
{
    echo "##### BUILD @1"

    local findstr=@2
    test -z "@{findstr}" && findstr=@1
    ls /var/cache/hooks/30_aur/aur/@{findstr}* && return

    test -d @1 || git clone https://aur.archlinux.org/@1.git
    cd @1
    #makepkg --syncdeps --noconfirm
    makepkg --syncdeps --noconfirm --nobuild
    makepkg --syncdeps --noconfirm --noextract --install
    rm -f *debug*.zst
    mv *.zst /var/cache/hooks/30_aur/aur/
    cd ..
    rm -Rf @1
}

build oh-my-zsh-git
build adwaita-qt-git adwaita-qt
build ddrescueview
build chunkfs

#build epson-perfection-v10-v100-scanner-driver-aio
build proot

build kubelogin
build kafkactl

build wdisplays
build vdu_controls

# electron
build skypeforlinux-bin
build openlens-bin
build superproductivity-bin
build yandex-browser
build monokle-bin
#build teams-for-linux # npm error
#build mqtt-explorer-beta # npm error

build code-features
build code-server

# tools
build apachedirectorystudio
build jmeter
build appimagetool-bin
build zenmap
build gqrx
build noisetorch
build onedrive-abraunegg
build p7zip-gui

# firefox
build firefox-extension-tab-session-manager
#build firefox-extension-tab-stash
build firefox-extension-proxy-switchyomega
build firefox-extension-multi-account-containers
build firefox-extension-dont-track-me-google

# build steamguard-cli-git

# yandex music
build python-yandex-music-api
build rhythmbox-plugin-yandex-music

# programing lang servers and debug
build cs-script
build netcoredbg
build gomodifytags
build gotests
build jdtls
build kotlin-language-server
build lemminx
#build openscad-lsp-git

# translate system
build sentencepiece
build python-sentencepiece
build python-sacremoses
build python-stanza
build ctranslate2
build python-ctranslate2
build argos-translate
build argos-translate-gui

# Long time builds
build miniconda3
build qflipper-git
build gittyup-appimage
build albert


gpg --recv-keys BF38D4D02A328DFF
build stellarium-bin
build jfrog-cli-bin
build aqemu
build qtemu-git
EOF

exit 0
