# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GTK based utility to parse the contents of elogs created by Portage"
HOMEPAGE="http://forums.gentoo.org/viewtopic-p-3374725.html#3374725"

SRC_URI="http://www.v-li.de/temp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/python-2.3
	>=sys-apps/portage-2.1
	>=dev-python/pygtk-2.0"

src_install() {
	  dobin "${WORKDIR}"/elogviewer
	  dodoc "${WORKDIR}"/CHANGELOG
	  doman "${FILESDIR}"/elogviewer.1
}

pkg_postinst() {
	einfo
	einfo "In order to use this software, you need to activate"
	einfo "Portage's EINFO features.  Required is"
	einfo "	     PORTAGE_EINFO_SYSTEM=\"save\" "
	einfo "and at least one out of "
	einfo "	     PORTAGE_EINFO_CLASSES=\"warn error info log\""
	einfo "More information on the EINFO system can be found"
	einfo "in /etc/make.conf.example"
	einfo
	einfo "To operate properly this software needs the directory"
	einfo "$PORT_LOGDIR/einfo created, belonging to group portage."
	einfo "To start the software as a user, add yourself to the portage"
	einfo "group."
	einfo
}
