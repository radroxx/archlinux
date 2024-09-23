function install_pkgs_list()
{
    # acpi
    pkgs="$pkgs acpi acpid"

    #pkgs="$pkgs acpi_call"


    ### Block devices
    # block dev
    pkgs="$pkgs mdadm lvm2 cryptsetup"

    # fs
    pkgs="$pkgs btrfs-progs ntfs-3g dosfstools exfat-utils squashfs-tools mtpfs mtd-utils jfsutils"

    # network fs
    pkgs="$pkgs sshfs nfs-utils cifs-utils"
    
    # archives
    pkgs="$pkgs mkinitcpio-busybox cpio"
    
    # utils
    pkgs="$pkgs iotop ddrescue nvme-cli smartmontools"




    # Drivers GPU Intel
    pkgs="$pkgs lib32-vulkan-intel libva-intel-driver lib32-libva-intel-driver"

    # Drivers GPU Radeon
    pkgs="$pkgs lib32-vulkan-radeon"

    # Drivers GPU Nvidia
    pkgs="$pkgs lib32-vulkan-nouveau nvidia lib32-nvidia-utils nvidia-settings nvidia-prime opencl-nvidia"

    # GPU top
    pkgs="$pkgs nvtop"

}