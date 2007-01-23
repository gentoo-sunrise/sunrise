# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils versionator

MY_PN="PythonCAD"
#MY_PV="DS$(replace_version_separator 1 '-R' $(get_version_component_range 2-))"
MY_PV="DS$(replace_version_separator 1 '-R' $(get_after_major_version))"

DESCRIPTION="CAD program written in PyGTK"
HOMEPAGE="http://www.pythoncad.org/"
LICENSE="GPL-2"
SRC_URI="http://www.pythoncad.org/releases/${MY_PN}-${MY_PV}.tar.bz2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-1.99.16"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_install() {
	distutils_src_install
	newbin gtkpycad.py pythoncad
	dodir /etc/${PN}
	insinto /etc/${PN}
	doins prefs.py
}
