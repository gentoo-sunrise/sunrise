# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A Python XMPP (RFC 3920,3921) and Jabber implementation"
HOMEPAGE="http://pyxmpp.jajcus.net/"
SRC_URI="http://pyxmpp.jajcus.net/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3
	>=dev-libs/libxml2-2.6.23"
RDEPEND=">=dev-python/dnspython-1.3.2
	>=dev-python/m2crypto-0.13.1"

pkg_setup() {
	if ! built_with_use dev-libs/libxml2 python ; then
		eerror "To build pyxmpp, libxml2 must be built with python"
		eerror "bindings. To continue merging pyxmpp, you must first "
		eerror "recompile libxml2 with the python use flag enabled"
		die "pyxmpp requires libxml2 with USE=python"
	fi
}

src_compile() {
	emake DESTDIR="${D}" build || die "emake build failed"
	dohtml -r doc/*
}
