# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib

DESCRIPTION="Fully automated disaster Recovery supporting a broad variety of backup strategies and scenarios"
HOMEPAGE="http://rear.github.com/"
SRC_URI="mirror://github/downloads/${PN}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="udev examples"

RDEPEND="net-dialup/mingetty
	net-fs/nfs-utils
	sys-apps/iproute2
	sys-apps/lsb-release
	sys-apps/util-linux
	sys-block/parted
	sys-boot/syslinux
	virtual/cdrtools
	udev? ( sys-fs/udev )
	"

src_install () {
	# deploy udev USB rule and udev will autostart ReaR workflows incase a USB
	# drive with the label 'REAR_000' is connected, which in turn is the
	# default label when running the `rear format` command.
	if use udev; then
		insinto $(get_libdir)/udev/rules.d
		doins etc/udev/rules.d/62-${PN}-usb.rules
	fi

	# copy configuration files and examples
	if use examples; then
		insinto /etc/
		doins -r etc/${PN}
	fi
	insinto /etc/${PN}/
	doins usr/share/${PN}/conf/default.conf

	# copy main script-file and docs
	dosbin usr/sbin/${PN}
	doman usr/share/${PN}/doc/${PN}.8
	dodoc README

	# cleanup usr/share/rear/ and install remains recursively.
	rm -r usr/share/${PN}/{AUTHORS,COPYING,README} || die
	insinto /usr/share/
	doins -r usr/share/${PN}
}

pkg_prerm () {
	if [[ -z "${REPLACED_BY_VERSION}" ]]; then
		# due to the nature of rear's image creation, there is a hard-coded
		# relative symlinks that leads to a recursion error upon deletion.
		rm "${EROOT}usr/share/${PN}/skel/default/lib/tls"
		# for some odd reason portage tries to delete the parent directory
		# befor the 'EXTERNAL' symlink is removed, leading to empty directory
		# remaining behind. we want to avoid this until it has been fixed upstream.
		rm "${EROOT}usr/share/${PN}/verify/EXTERNAL"
	fi
}
