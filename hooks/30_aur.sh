function install_pkgs_list(){
    # req by cisco anyconnect
    pkgs="$pkgs gst-libav webkit2gtk"
}

function patch_desktop_file()
{
    test -f /usr/share/applications/$1.original || cp /usr/share/applications/$1 /usr/share/applications/$1.original
    cat /usr/share/applications/$1.original \
        | sed 's#Exec=\(.*\)$#Exec=\1 --enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu#g' > /usr/share/applications/$1
}

function post_install_hook()
{
    test -L /usr/bin/scriptcs || ln -s cscs /usr/bin/scriptcs

    cp /var/cache/hooks/30_aur/zshrc /etc/skel/.zshrc
    sed -i 's/\/bash/\/zsh/g' /etc/default/useradd

    grep /usr/bin/zsh /etc/shells || echo "/usr/bin/zsh" >> /etc/shells

    sed -i 's/QT_STYLE_OVERRIDE=.*/QT_STYLE_OVERRIDE=Adwaita-Dark/g' /etc/xdg/labwc/environment

    # translate
    mkdir -p /usr/share/argos-translate/packages/
    export ARGOS_PACKAGES_DIR=/usr/share/argos-translate/packages/

	/usr/bin/argospm install translate-en_ru
	/usr/bin/argospm install translate-ru_en
	/usr/bin/argospm install translate-en_el
	/usr/bin/argospm install translate-el_en

	chmod go+w -R /usr/share/argos-translate/packages/*/stanza

	echo ARGOS_PACKAGES_DIR=/usr/share/argos-translate/packages/ >> /etc/environment

    # wayland patch

    chmod 755 /opt/yandex
    chmod 755 /opt/yandex/browser
    patch_desktop_file yandex-browser.desktop
    patch_desktop_file OpenLens.desktop
    patch_desktop_file mqtt-explorer-beta.desktop
}