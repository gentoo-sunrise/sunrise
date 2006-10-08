# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

LASTDOCS="0.4.1"
DESCRIPTION="Library for XSPF playlist reading and writing"
HOMEPAGE="http://libspiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	doc? ( mirror://sourceforge/${PN}/${PN}-${LASTDOCS}-doc.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=dev-libs/expat-1.95.8"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use doc; then
		mv ../${PN}-${LASTDOCS}-doc doc
	fi
}

src_compile() {
	econf || die "configure failed"
	emake || die "emake failed"

	if use doc; then
		ebegin "Creating documentation"
		cd ${S}/doc
		doxygen Doxyfile
		eend 0
	fi
}


src_install() {
	emake DESTDIR=${D} install || die "make install failed"
	dodoc README AUTHORS ChangeLog

	if use doc; then
		insinto /usr/share/doc/${PF}/api
		doins doc/html/*
	fi

}
