# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Curses based utility to parse the contents of elogs created by Portage"
HOMEPAGE="http://luca89.wordpress.com/elogv/"
SRC_URI="http://gechi-overlay.sourceforge.net/distfiles/elogv/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/python-2.4
	>=sys-apps/portage-2.1"

S="${WORKDIR}/elogv"

pkg_setup() {
	if ! built_with_use dev-lang/python ncurses; then
	   eeror
	   eerror "\t ${PN} requires ncurses support on python"
	   eerror "\t Please, compile python with use ncurses enabled then"
	   eerror "\t remerge this package"
	   eeror
	   die "dev-lang/python must have ncurses use turned on"
	fi
}

src_install() {
	 newbin ${PN}.py ${PN}
	 dodoc README AUTHORS ChangeLog
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