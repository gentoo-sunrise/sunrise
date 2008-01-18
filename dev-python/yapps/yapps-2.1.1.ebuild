# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.2

inherit distutils versionator

MY_P="${PN}$(delete_version_separator '-')"
DESCRIPTION="An easy to use parser generator."
HOMEPAGE="http://theory.stanford.edu/~amitp/yapps/"
SRC_URI="http://www-cs-students.stanford.edu/~amitp/yapps/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/Yapps-${PV}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
