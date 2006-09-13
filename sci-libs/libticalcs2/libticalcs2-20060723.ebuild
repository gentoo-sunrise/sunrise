# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="library for communication with TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="mirror://sourceforge/gtktiemu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND=">=dev-libs/glib-2
	sci-libs/libticables2
	sci-libs/libticonv
	sci-libs/libtifiles2
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/libticalcs

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS LOGO NEWS README ChangeLog docs/api.txt
	dohtml docs/html/*
}
