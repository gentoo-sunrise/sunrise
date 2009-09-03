# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="CD/DVD image converter using libmirage"
HOMEPAGE="http://proj.mgorny.alt.pl/mirage2iso/"
SRC_URI="http://proj.mgorny.alt.pl/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="<dev-libs/libmirage-1.2"
RDEPEND="${DEPEND}"

src_configure() {
	emake configure || die 'configure failed'
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install || die 'install failed'

	dodoc README || die 'dodoc failed'
}
