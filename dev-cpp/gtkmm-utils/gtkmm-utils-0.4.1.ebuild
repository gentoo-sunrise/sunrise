# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

MY_PVM=$(get_version_component_range 1-2)

DESCRIPTION="Utility functions, classes and widgets written on top of gtkmm and glibmm."
HOMEPAGE="http://code.google.com/p/gtkmm-utils/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-cpp/gtkmm:2.4"
DEPEND="
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

src_configure() {
	econf $(use_enable doc documentation)
}
