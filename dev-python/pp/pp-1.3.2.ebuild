# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Parallel and distributed programming for Python"
HOMEPAGE="http://www.parallelpython.com"
SRC_URI="http://www.parallelpython.com/downloads/${PN}/${P}.tar.gz
	examples? ( http://www.parallelpython.com/downloads/${PN}/ppexamples.tar.gz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${WORKDIR}"/examples
	fi
}
