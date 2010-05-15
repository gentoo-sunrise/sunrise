# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="Simple udev-based automounter for removable USB media"
HOMEPAGE="http://proj.mgorny.alt.pl/uam/"
SRC_URI="http://dl.mgorny.alt.pl/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-fs/udev"

src_compile() {
	emake LIBDIR=/$(get_libdir) || die
}

src_install() {
	emake LIBDIR=/$(get_libdir) DESTDIR="${D}" install || die

	dodoc NEWS README TODO || die
}

pkg_postinst() {
	# such group is created by pam, pmount any many other ebuilds
	# but we don't want to depend on any of them (even pmount is optional)
	enewgroup plugdev

	elog "To be able to access uam-mounted filesystems, you have to be member"
	elog "of the 'plugdev' group."
	elog
	elog "Note that uam doesn't provide any way to allow unprivileged user to"
	elog "manually umount devices. You may use pumount from sys-apps/pmount"
	elog "for that. Otherwise, remember to sync before removing your USB stick."
	elog
	elog "If you'd like to receive libnotify-based notifications, you need"
	elog "to install the [x11-misc/sw-notify-send] tool."

	ebegin "Calling udev to reload its rules"
	udevadm control --reload-rules
	eend $?
}
