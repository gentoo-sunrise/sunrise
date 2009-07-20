# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Simple udev-based automounter for removable USB media"
HOMEPAGE="http://proj.mgorny.alt.pl/uam/"
SRC_URI="http://proj.mgorny.alt.pl/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-fs/udev"

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'

	dodoc NEWS README TODO || die 'dodoc failed'
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

	ebegin "Calling udev to reload its rules"
	udevadm control --reload-rules
	eend $?
}
