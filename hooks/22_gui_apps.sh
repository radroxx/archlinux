function install_pkgs_list(){
    
    # Wayland
    pkgs="$pkgs grim slurp wf-recorder waybar nwg-menu fuzzel kanshi gammastep brightnessctl wl-clipboard"
    pkgs="$pkgs wtype wev kwayland5"
    
    # Theme
    pkgs="$pkgs adapta-gtk-theme"

    # wayland screen share
    pkgs="$pkgs xdg-desktop-portal-wlr pipewire pipewire-media-session "

    # console
    pkgs="$pkgs terminator wezterm"

    # browsers
    pkgs="$pkgs netsurf firefox firefox-i18n-ru firefox-i18n-en-us firefox-spell-ru"
    pkgs="$pkgs firefox-extension-passff firefox-dark-reader firefox-adblock-plus firefox-ublock-origin"

    # messangers and email
    pkgs="$pkgs telegram-desktop beebeep deltachat-desktop evolution"

    # security apps
    pkgs="$pkgs seahorse gnome-keyring pinentry qtpass veracrypt kgpg"

    # text edit
    pkgs="$pkgs geany meld okteta"

    # qemu ui
    pkgs="$pkgs qemu-desktop"

    # scad
    pkgs="$pkgs openscad freecad"

    # file manager
    pkgs="$pkgs nemo thunar tumbler engrampa filezilla"

    # remote desctop
    pkgs="$pkgs remmina freerdp"

    # office
    pkgs="$pkgs libreoffice-fresh libreoffice-fresh-ru gnumeric hunspell-ru languagetool"

    # audio video photo
    pkgs="$pkgs audacity rhythmbox pavucontrol pulseview pitivi kdenlive phototonic pinta vlc"
    
    # tools
    pkgs="$pkgs qbittorrent wireshark-qt kdeconnect marble dbeaver spyder putty kdesvn kommit qgit"
    pkgs="$pkgs network-manager-applet mate-system-monitor urh lapce clamtk mako"
    pkgs="$pkgs font-manager keepassxc"

    # electron
    pkgs="$pkgs electron chromium code"

    # X11 only
    pkgs="$pkgs xorg-xwayland gparted"

    # pipewire
    pkgs="$pkgs qpwgraph pipewire-alsa"

    # pulseaudio
    pkgs="$pkgs pavucontrol"
}

function post_install_hook()
{
    mkdir -p /etc/xdg/labwc
    cp /var/cache/hooks/22_gui_apps/labwc_rc.xml /etc/xdg/labwc/rc.xml
    cp /var/cache/hooks/22_gui_apps/labwc_menu.xml /etc/xdg/labwc/menu.xml
    cp /var/cache/hooks/22_gui_apps/labwc_autostart /etc/xdg/labwc/autostart
    cp /var/cache/hooks/22_gui_apps/labwc_env /etc/xdg/labwc/environment

    cp /var/cache/hooks/22_gui_apps/waybar_config.jsonc /etc/xdg/waybar/config.jsonc
    cp /var/cache/hooks/22_gui_apps/waybar_style.css /etc/xdg/waybar/style.css

    cp /var/cache/hooks/22_gui_apps/menu-start.css /usr/share/nwg-menu/menu-start.css

    mkdir -p /etc/gtk-3.0
    mkdir -p /etc/gtk-2.0
    cp /var/cache/hooks/22_gui_apps/gtk3_settings.ini /etc/gtk-3.0/settings.ini
    cp /var/cache/hooks/22_gui_apps/gtk2_gtkrc /etc/gtk-2.0/gtkrc

    mkdir -p /etc/skel/.config/
    cp /var/cache/hooks/22_gui_apps/electron-flags.conf /etc/skel/.config/electron30-flags.conf
    test -L /etc/skel/.config/skypeforlinux-flags.conf || ln -s electron30-flags.conf /etc/skel/.config/skypeforlinux-flags.conf
    test -L /etc/skel/.config/chromium-flags.conf || ln -s electron30-flags.conf /etc/skel/.config/chromium-flags.conf
}
