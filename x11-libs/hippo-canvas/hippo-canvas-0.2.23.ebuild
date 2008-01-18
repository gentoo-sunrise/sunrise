# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG="no"
inherit autotools gnome2 eutils

DESCRIPTION="A canvas library based on GTK+-2, Cairo, and Pango"
HOMEPAGE="http://developer.mugshot.org/wiki/Hippo_Canvas"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Removed USE=doc for now since configure.ac needs fixing
# otherwise eautoreconf fails
IUSE="python" # doc

RDEPEND=">=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	python? ( dev-lang/python
		dev-python/pycairo
		dev-python/pygtk )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/gtk-doc-1.6"
	# doc? ( >=dev-util/gtk-doc-1.6 )"

DOCS="AUTHORS README TODO"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-use-python.patch"
	eautoreconf
}

pkg_setup() {
	G2CONF="$(use_enable python)"
}
