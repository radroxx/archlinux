function install_pkgs_list(){
    # wine and game
    pkgs="$pkgs vkd3d vulkan-tools vulkan-icd-loader vulkan-validation-layers"
    pkgs="$pkgs vulkan-extra-layers vulkan-mesa-layers libva-utils"
    pkgs="$pkgs lib32-vkd3d lib32-vulkan-icd-loader lib32-vulkan-validation-layers lib32-vulkan-mesa-layers"
    
    # mesa
    pkgs="$pkgs mesa libva-mesa-driver mesa-vdpau glu lib32-mesa lib32-libva-mesa-driver lib32-mesa-vdpau lib32-glu"
    pkgs="$pkgs mesa-demos libvdpau-va-gl libva-vdpau-driver lib32-libva-vdpau-driver lib32-mesa-vdpau"
}