# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils versionator

MY_PN="PythonCAD"
MY_PV="DS$(replace_version_separator 1 '-R' $(get_after_major_version))"
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="CAD program written in PyGTK"
HOMEPAGE="http://www.pythoncad.org/"
LICENSE="GPL-2"
SRC_URI="http://www.pythoncad.org/releases/${MY_P}.tar.bz2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-1.99.16"
DEPEND="${RDEPEND}"

PYTHON_MODNAME=${MY_PN}

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
	newbin gtkpycad.py pythoncad
	insinto /etc/${PN}
	doins prefs.py
}
