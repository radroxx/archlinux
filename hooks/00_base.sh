

function install_pkgs_list()
{
    pkgs="$pkgs base busybox posix sudo man-db zsh rsync lzop openssh terminus-font imvirt"

	pkgs="$pkgs xdg-user-dirs glibc-locales"

	pkgs="$pkgs mailcap hunspell"
}

function pre_install_hook()
{
	/var/cache/build/busybox sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf
	
	# add multilib repo
	cat /etc/pacman.conf | tr '\n' '\r' \
		| /var/cache/build/busybox sed -e 's/#\[multilib\]\r#/[multilib]\r/g' \
		| tr '\r' '\n' > /etc/pacman.conf.tmp
	mv /etc/pacman.conf.tmp /etc/pacman.conf

	# include into initrd
	cp /var/cache/hooks/00_base/vconsole.conf /etc/vconsole.conf
}

function post_install_hook()
{
	# add sudo
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
	chmod -w /etc/sudoers.d/wheel

	systemctl enable dbus-broker.service
	systemctl --global enable xdg-user-dirs-update
}