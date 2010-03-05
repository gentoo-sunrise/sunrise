# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PVM=$(get_version_component_range 1-2)

DESCRIPTION="Utility functions, classes and widgets written on top of gtkmm and glibmm."
HOMEPAGE="http://code.google.com/p/gtkmm-utils/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=dev-cpp/gtkmm-2.10.0"
DEPEND="doc? ( app-doc/doxygen )
	dev-util/pkgconfig
	${RDEPEND}"

src_compile() {
	econf $(use_enable doc documentation)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
