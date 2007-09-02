# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools gnome.org eutils

DESCRIPTION="A canvas library based on GTK+-2, Cairo, and Pango"
HOMEPAGE="http://developer.mugshot.org/wiki/Hippo_Canvas"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc python"

RDEPEND=">=dev-libs/glib-2.6
		>=x11-libs/gtk+-2.6
		python? ( dev-lang/python
			dev-python/pycairo
			dev-python/pygtk )"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		doc? ( >=dev-util/gtk-doc-1.6 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-use-python.patch"
	eautoreconf
}

src_compile() {
	econf $(use_enable doc gtk-doc) $(use_enable python) ||
		die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README TODO || die "dodoc failed"
}
