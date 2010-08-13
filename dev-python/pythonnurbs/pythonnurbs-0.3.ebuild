# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

MY_PN="PythonNURBS"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python language bindings for the NURBS++ library"
HOMEPAGE="http://pypi.python.org/pypi/PythonNURBS"
SRC_URI="mirror://pypi/P/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="sci-libs/nurbs++"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}/${MY_P}"
