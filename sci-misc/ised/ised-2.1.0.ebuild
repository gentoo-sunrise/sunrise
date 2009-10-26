# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A tool for generating sequences and arithmetic evaluation of stream data."
HOMEPAGE="http://ised.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="long-types"

DEPEND="sys-libs/readline"
RDEPEND="${DEPEND}"

src_configure() {
	use long-types && local type_conf="INT_TYPE=LONG FLOAT_TYPE=LONG"
	econf --with-readline ${type_conf}
}

src_install() {
	emake install DESTDIR="${D}" || die 'install failed'
	dodoc AUTHORS ChangeLog NEWS README || die 'dodoc failed'
}
