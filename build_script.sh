HOOKS_DIR=/var/cache/hooks
pkgs="squashfs-tools"

hooks=$(ls ${HOOKS_DIR}/ | grep "\.sh$")

# Get pkgs list
for hook in ${hooks}
do
    function install_pkgs_list(){ true; }
    source ${HOOKS_DIR}/${hook}
    install_pkgs_list
done

export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin
export LC_ALL=C.utf8

echo -e "\n\n\n\n"
echo "################################################################################"
echo "##########                    PRE INSTALL HOOKS                       ##########"
echo "################################################################################"
# pre install hook
for hook in ${hooks}
do
    function pre_install_hook(){ true; }
    source ${HOOKS_DIR}/${hook}

    echo "########## RUN ${hook}"
    pre_install_hook
done

echo -e "\n\n\n\n"
echo "################################################################################"
echo "##########                      DOWNLOAD PKGS                         ##########"
echo "################################################################################"
# Download pkgs
pacman --sync --noconfirm --refresh --downloadonly ${pkgs}

echo -e "\n\n\n\n"
echo "################################################################################"
echo "##########                       INSTALL PKGS                         ##########"
echo "################################################################################"
# Install pkgs
pacman --sync --noconfirm --noscriptlet ${pkgs}


echo -e "\n\n\n\n"
echo "################################################################################"
echo "##########                       INSTALL AUR                          ##########"
echo "################################################################################"
# Install pkgs
pacman -U --noconfirm /var/cache/hooks/*/aur/*

echo -e "\n\n\n\n"
echo "################################################################################"
echo "##########                   POST INSTALL HOOKS                       ##########"
echo "################################################################################"
# post install hooks
for hook in ${hooks}
do
    function post_install_hook(){ true; }
    source ${HOOKS_DIR}/${hook}

    echo "########## RUN ${hook}"
    post_install_hook
done

echo -e "\n\n\n\n"
echo "################################################################################"
echo "##########                     MAKE SQUASHFS                          ##########"
echo "################################################################################"
mksquashfs / /boot/archlinux.squash -comp xz -b 1M -no-xattrs -always-use-fragments -noappend \
 	-no-recovery -processors 6 -mem 1024M -no-progress -wildcards \
 	-e 'boot/*' -e 'dev/*' -e 'proc/*' -e 'run/*' -e 'sys/*' -e 'tmp/*' -e 'var/cache/*' -e 'root/*' -e 'build'
