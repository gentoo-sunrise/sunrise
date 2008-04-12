# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Ncurses file manager with a full-screen user interface"
HOMEPAGE="http://www.clex.sk/"
SRC_URI="http://www.clex.sk/download/${P}.tar.gz
	doc? ( http://www.clex.sk/download/${PN}-html-help-${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="doc"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog

	use doc && dohtml "${WORKDIR}"/${PN}-html-help-${PV}/*
}
