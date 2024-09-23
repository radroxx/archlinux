function install_pkgs_list(){

    # session manager
    pkgs="$pkgs greetd"

    # fonts
    pkgs="$pkgs ttf-dejavu ttf-inconsolata ttf-liberation adobe-source-han-sans-otc-fonts otf-font-awesome ttf-font-awesome"
    
    # icons
    pkgs="$pkgs mate-themes mate-icon-theme-faenza"

    # sway
    pkgs="$pkgs sway swaylock swaybg"
    
    # local find system
    pkgs="$pkgs recoll"
    
    # joystic tools
    pkgs="$pkgs joyutils"

    # pulseaudio and bluetooth
    pkgs="$pkgs pulseaudio-bluetooth blueman"

    pkgs="$pkgs ffmpeg mpd"

    # X11
    pkgs="$pkgs xorg-server-xvfb openbox xterm"
}