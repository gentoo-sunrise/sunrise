# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{3_1,3_2,3_3} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Fast and simple packet creating / parsing supporting various protocols."
HOMEPAGE="https://github.com/mike01/pypacker"
SRC_URI="https://github.com/mike01/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( AUTHORS CHANGES HACKING README )

python_test() {
	"${PYTHON}" tests/test_pypacker.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
