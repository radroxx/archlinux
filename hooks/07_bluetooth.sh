function install_pkgs_list()
{
    pkgs="$pkgs bluez-tools bluez-utils"
}

function post_install_hook()
{
    cp /var/cache/hooks/07_bluetooth/input.conf /etc/bluetooth/input.conf
    systemctl enable bluetooth.service
}