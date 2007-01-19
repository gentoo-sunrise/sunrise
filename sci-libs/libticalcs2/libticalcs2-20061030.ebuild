# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="library for communication with TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="mirror://sourceforge/gtktiemu/${P}.tar.bz2
	mirror://sourceforge/gtktiemu/${P}-64bit.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND=">=dev-libs/glib-2
	sci-libs/libticables2
	sci-libs/libticonv
	>=sci-libs/libtifiles2-20061030
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/libticalcs

src_unpack() {
	unpack "${P}.tar.bz2"
	cd "${S}"
	[[ $(tc-arch) == "amd64" ]] && epatch "${DISTDIR}"/${P}-64bit.diff
}

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS LOGO NEWS README ChangeLog docs/api.txt
	dohtml docs/html/*
}
