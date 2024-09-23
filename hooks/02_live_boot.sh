function install_pkgs_list(){
    return
}

function pre_install_hook()
{
	install -v -m 644 -D -t /usr/lib/initcpio/install/ /var/cache/hooks/02_live_boot/sd-livearch
	install -v -m 644 -D -t /usr/lib/systemd/system/ /var/cache/hooks/02_live_boot/initrd-root-live.service
	install -v -m 755 -D -t /usr/local/livearch/ /var/cache/hooks/02_live_boot/live
	install -v -m 755 -D -t /usr/local/livearch/ /var/cache/hooks/02_live_boot/preboot

	mkdir -p /usr/lib/systemd/system/sysroot.mount.requires/
	test -L /usr/lib/systemd/system/sysroot.mount.requires/initrd-root-live.service \
		|| ln -s ../initrd-root-live.service /usr/lib/systemd/system/sysroot.mount.requires/initrd-root-live.service
}