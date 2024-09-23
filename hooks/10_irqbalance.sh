function install_pkgs_list()
{
    pkgs="$pkgs irqbalance"
}

function post_install_hook()
{
    systemctl enable irqbalance.service
}