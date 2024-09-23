function install_pkgs_list()
{
    pkgs="$pkgs efibootmgr inotify-tools"

    pkgs="$pkgs wget curl run-parts rsync zsh pv p7zip lsof"

    pkgs="$pkgs jq fx yq colordiff yamllint thefuck"
    pkgs="$pkgs cowsay sane imagemagick"

    pkgs="$pkgs sqlite rclone sysstat strace vault"

    # perfmon
    pkgs="$pkgs powertop atop htop"

    # pacman devtools
    pkgs="$pkgs devtools pkgfile pacman-contrib pacman-mirrorlist"

    # appimage
    pkgs="$pkgs libappimage"

    # tui
    pkgs="$pkgs vim vifm tmux mc neofetch links mutt hexedit minicom"

    # mail tools
    pkgs="$pkgs nullmailer swaks offlineimap msmtp"
}


function post_install_hook()
{
    cp /var/cache/hooks/05_utils/vimrc /etc/vimrc
    test -L /usr/bin/vi || ln -s vim /usr/bin/vi
}