# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="A fast, free, high-quality, multi-platform XSL formatter"
HOMEPAGE="http://xmlroff.org/"
SRC_URI="http://xmlroff.org/download/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo debug doc svg truetype"

# at least ciaro or gnome-print is required (as backend)

RDEPEND="x11-libs/gtk+
	x11-libs/pango
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/libxslt
	cairo? ( x11-libs/cairo )
	!cairo? ( gnome-base/libgnomeprint )
	svg? ( gnome-base/librsvg )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
		$(use_enable cairo) \
		$(use_enable !cairo gp) \
		$(use_enable debug libfo-debug)

	emake || die "emake failed"
}

src_install() {
	local docdir="/usr/share/doc/${PF}"

	emake DESTDIR="${D}" HTML_DIR="${docdir}" install || die "emake install failed"

	if use doc; then
		mv "${D}/${docdir}/${PN}" "${D}/${docdir}/html" || die
	else
		rm -r "${D}/${docdir}/${PN}" || die
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"
}
