# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils versionator

MY_P="${PN}$(delete_version_separator '-')"
DESCRIPTION="Yapps is an easy to use parser generator."
HOMEPAGE="http://theory.stanford.edu/~amitp/yapps/"
SRC_URI="http://www-cs-students.stanford.edu/~amitp/yapps/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/Yapps-${PV}

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PN}/examples
	doins examples/*
}
