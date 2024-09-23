function install_pkgs_list()
{
    pkgs="$pkgs linux-zen linux-zen-headers linux-firmware"

    # modules
    pkgs="$pkgs dkms"

    # initrd
    pkgs="$pkgs mkinitcpio"

    # base devs
    pkgs="$pkgs intel-ucode amd-ucode mdadm"

    # kernel monitoring
    pkgs="$pkgs kmon linux-tools-meta"
}

function pre_install_hook()
{
    cp /var/cache/hooks/03_kernel/mkinitcpio.conf /etc/mkinitcpio.conf
}