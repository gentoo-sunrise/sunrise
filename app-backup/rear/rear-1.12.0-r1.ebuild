# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Fully automated disaster Recovery for GNU/Linux"
HOMEPAGE="http://rear.github.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-cdr/cdrtools
	net-dialup/mingetty
	net-fs/nfs-utils
	sys-apps/iproute2
	sys-apps/lsb-release
	sys-apps/util-linux
	sys-block/parted
	sys-boot/syslinux
	sys-fs/udev
	"

src_prepare () {
	epatch "${FILESDIR}/${P}-broken_lib_dir_workaround.patch"
}

src_install () {
	insinto /usr/share/
	doins -r usr/share/rear
	insinto /etc/
	doins -r etc/rear
	insinto /lib/udev/rules.d
	doins etc/udev/rules.d/62-rear-usb.rules
	insinto /etc/rear
	doins usr/share/rear/conf/default.conf
	dosbin usr/sbin/rear

	doman usr/share/rear/doc/rear.8
}

pkg_prerm () {
	if [[ -z "${REPLACED_BY_VERSION}" ]]; then
		# due to the nature of rear's image creation, there is a hard-coded
		# relative symlinks that leads to a recursion error upon deletion.
		rm "${EROOT}usr/share/rear/skel/default/lib/tls"
		# for some odd reason portage tries to delete the parent directory
		# befor the 'EXTERNAL' symlink is removed, leading to empty directory
		# remaining behind. we want to avoid this until it has been fixed upstream.
		rm "${EROOT}usr/share/rear/verify/EXTERNAL"
	fi
}
