# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="Dump a remote Subversion repository"
HOMEPAGE="http://rsvndump.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="dev-util/subversion"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto
	>=app-text/asciidoc-8.4 )"

src_prepare() {
	epatch "${FILESDIR}"/rsvndump-disable-man.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable doc man)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS || die "dodoc failed"
}
