# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Utilities to parse the contents of elogs created by Portage"
HOMEPAGE="http://forums.gentoo.org/viewtopic-p-3374725.html#3374725
http://jeremywick.phpnet.us/
http://dev.gentoo.org/~dberkholz/"

SRC_URI="gtk? http://www.v-li.de/temp/${P}.tar.gz
		kde? ( http://jeremywick.phpnet.us/kelogviewer.tgz )
		text? ( http://dev.gentoo.org/~dberkholz/scripts/eread )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="kde gtk text"

DEPEND=""
RDEPEND=">=dev-lang/python-2.3
	>=sys-apps/portage-2.1
	gtk? ( >=dev-python/pygtk-2.0 )
	kde? ( dev-python/PyQt
	     kde-base/pykde )
	text? ( app-shells/bash )"

src_unpack() {
	if !  `use text || use kde || use gtk`; then
	   eerror
	   eerror "You must specify at least one USE flag out of \"gtk kde text\""
	   eerror
	fi

	unpack ${A}
}

src_install() {
	if use kde; then
	   dobin "${WORKDIR}"/kelogviewer
	fi
	if use gtk; then
	  dobin "${WORKDIR}"/elogviewer
	  dodoc "${WORKDIR}"/CHANGELOG
	  doman "${FILESDIR}"/elogviewer.1
	fi
	if use text; then
	   dobin "${DISTDIR}"/eread
	fi
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
	einfo "You chose"
	use gtk && einfo "\t GTK frontend, which is called throug /usr/bin/elogviewer"
	use kde && einfo "\t KDE frontend, which is called by /usr/bin/kelogviewer"
	use text && einfo "\t text frontend, which is called be /usr/bin/eread"
	einfo
}
