function install_pkgs_list()
{
    pkgs="$pkgs alsa-firmware alsa-utils lib32-alsa-plugins"

    # pulseaudio
    pkgs="$pkgs pulseaudio-alsa"
    
    # pipewire
    #pkgs += pipewire-alsa qpwgraph
}