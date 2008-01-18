# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="The Console Jabber Client - Jabber client with text-based user interface"
HOMEPAGE="http://cjc.jajcus.net/trac/"
SRC_URI="http://cjc.jajcus.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

IUSE=""
DEPEND=""
RDEPEND=">=dev-lang/python-2.4.2
	>=net-im/pyxmpp-1.0.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-plugins-dir.patch"
	epatch "${FILESDIR}/${P}-path-fix.patch"
	epatch "${FILESDIR}/${P}-Makefile-fix.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dohtml doc/manual.html
}
