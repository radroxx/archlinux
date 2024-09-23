function install_pkgs_list()
{
    # base
    pkgs="$pkgs nftables iptables-nft net-tools bridge-utils bind-tools whois tftp-hpa"

    # services
    pkgs="$pkgs dnsmasq"

    # wifi
    pkgs="$pkgs wpa_supplicant hostapd wireless-regdb"

    # vpn
    pkgs="$pkgs openvpn wireguard-tools strongswan tor"

    # utils
    pkgs="$pkgs iperf3 iftop mtr traceroute tcpdump socat openbsd-netcat arpwatch nmap"
}

function post_install_hook()
{
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/06-network.conf

    mkdir -p /etc/systemd/network/
    cp /var/cache/hooks/06_network/00_default.network /etc/systemd/network/00_default.network

    systemctl enable systemd-timesyncd
    systemctl enable systemd-networkd
}