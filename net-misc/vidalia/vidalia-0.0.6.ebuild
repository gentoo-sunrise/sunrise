# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Qt 4 front-end for Tor"
HOMEPAGE="http://www.vidalia-project.net/"
SRC_URI="http://www.vidalia-project.net/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=x11-libs/qt-4.1.1"
RDEPEND="$(DEPEND)
	>=net-misc/tor-0.1.1.20"

pkg_setup() {
	if use debug && ! built_with_use ">=x11-libs/qt-4.1.1" debug  ; then
		eerror "In order to have debug support for Vidalia"
		eerror "you need to compile Qt 4 with debug support too."
		die "Qt 4 built without debug support"
	fi
}

src_compile() {
	econf $(use_enable debug) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
