# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="KDE based utility to parse the contents of elogs created by Portage"
HOMEPAGE="http://jeremywick.phpnet.us/"
SRC_URI="http://jeremywick.phpnet.us/kelogviewer.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/python-2.3
	>=sys-apps/portage-2.1
	dev-python/PyQt
	kde-base/pykde"

src_install() {
	dobin "${WORKDIR}"/kelogviewer
}

pkg_postinst() {
	elog
	elog "In order to use this software, you need to activate"
	elog "Portage's elog features.  Required is"
	elog "	     PORTAGE_elog_SYSTEM=\"save\" "
	elog "and at least one out of "
	elog "	     PORTAGE_elog_CLASSES=\"warn error info log\""
	elog "More information on the elog system can be found"
	elog "in /etc/make.conf.example"
	elog
	elog "To operate properly this software needs the directory"
	elog "$PORT_LOGDIR/elog created, belonging to group portage."
	elog "To start the software as a user, add yourself to the portage"
	elog "group."
	elog
}
