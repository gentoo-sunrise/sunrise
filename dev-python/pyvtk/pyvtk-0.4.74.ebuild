# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

MY_PN="PyVTK"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tools for manipulating VTK files in Python"
HOMEPAGE="http://cens.ioc.ee/projects/pyvtk/"
SRC_URI="http://cens.ioc.ee/projects/pyvtk/rel-0.x/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch
}
