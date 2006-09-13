# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="charset conversion library for TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="mirror://sourceforge/gtktiemu/${P}.tar.bz2"

PATCHES="${FILESDIR}/${P}-bugfixes-20060807.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND=">=dev-libs/glib-2
	nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${PATCHES}
}

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS LOGO NEWS README ChangeLog docs/api.txt
	dohtml docs/html/*
	docinto charsets
	dohtml docs/charsets/*
}
