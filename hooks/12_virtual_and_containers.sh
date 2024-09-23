function install_pkgs_list()
{
    # docker and k8s
    pkgs="$pkgs docker docker-compose"

    # qemu
    pkgs="$pkgs qemu-emulators-full ovmf"

    # gui
    #pkgs="$pkgs qemu-desktop"
}