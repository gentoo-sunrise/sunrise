# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit distutils eutils

MY_P=PyYAML-${PV}

DESCRIPTION="PyYAML is a YAML parser and emitter for the Python programming language."
HOMEPAGE="http://pyyaml.org/"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples libyaml"

DEPEND="libyaml? ( dev-libs/libyaml dev-python/pyrex )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PYTHON_MODNAME=yaml

src_unpack() {
	unpack ${A}
	cd "${S}"
	use libyaml && epatch "${FILESDIR}/${P}-libyaml.patch"
}
src_install() {
	distutils_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
