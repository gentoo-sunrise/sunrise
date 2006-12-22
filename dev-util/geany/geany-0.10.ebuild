# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.4"
inherit autotools

DESCRIPTION="Fast and lightweight IDE using GTK2"
HOMEPAGE="http://geany.uvena.de/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	http://files.uvena.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 Scintilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/atk-1.9.0
	>=dev-libs/expat-1.95.8
	>=media-libs/fontconfig-2.2.3
	>=media-libs/freetype-2.1.9-r1
	>=media-libs/libpng-1.2.8
	>=x11-libs/gtk+-2.6.0
	>=x11-libs/pango-1.10.2
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Add syntax highlighting for Portage
	sed -i "data/filetype_extensions.conf" \
		-e 's:*.sh;:*.sh;*.ebuild;*.eclass;:' \
		|| die "sed filetype_extensions.conf failed"

	# GPL-2 references
	local licdir="${PORTDIR}/licenses"
	local lic="${licdir}/GPL-2"
	sed -i doc/geany.1.in \
		-e "s:@GEANY_DATA_DIR@/GPL-2:${lic}:" \
		|| die "sed geany.1.in failed"

	sed -i src/about.c \
		-e "s:\"GPL-2\", app->datadir:\"GPL-2\", \"${licdir}\":" \
		|| die "sed about.c failed"
}

src_compile() {
	eautoreconf || die "eautoreconf failed"
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Shuffle docs
	local docdir="${D}/usr/share/doc/${PN}"
	rm -f "${docdir/\/doc}"/GPL-2
	rm -f "${docdir}"/{COPYING,ScintillaLicense.txt}
	dohtml "${docdir}"/html/* || die "dohtml failed"
	dodoc "${docdir}"/* || die "dodoc failed"
	rm -rf "${docdir}"
}
