
function post_install_hook()
{
    cp /var/cache/hooks/21_labwc/config.toml /etc/greetd/config.toml
    systemctl enable greetd
}