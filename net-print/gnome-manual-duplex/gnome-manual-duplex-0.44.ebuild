# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.6"

inherit eutils multilib python

MY_PN=${PN/gnome/g}

DESCRIPTION="Utility that adds manual duplex to the Print menu"
HOMEPAGE="http://sourceforge.net/projects/g-manual-duplex/"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND="app-text/psutils
	dev-libs/libgamin[python]
	dev-python/pycups
	dev-python/pygobject:2
	dev-python/pygtk:2
	sys-apps/file
	gnome? (
		dev-python/gnome-applets-python
		gnome-base/gnome-panel[bonobo]
		)"
DEPEND="${RDEPEND}
	dev-util/gtk-builder-convert
	media-gfx/transfig
	media-libs/netpbm
	sys-devel/gettext"

src_prepare() {
	python_convert_shebangs -r 2 .
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_install() {
	local myinstall

	if use gnome ; then
		myinstall="install-gnome"
	else
		myinstall="install"
	fi

	emake \
		DESTDIR="${D}" \
		LIBDIR=$(get_libdir) \
		DOCDIR=/usr/share/doc/${PF} \
		$myinstall
}

pkg_postinst() {
	if use gnome ; then
		elog "Gnome-3 only works in fallback mode."
	fi
}
