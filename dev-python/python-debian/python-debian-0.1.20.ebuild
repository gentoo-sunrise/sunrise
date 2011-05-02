# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils

DESCRIPTION="Python modules to work with Debian-related data formats"
HOMEPAGE="http://packages.debian.org/sid/python-debian"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="dev-python/chardet"
DEPEND="${RDEPEND}
	dev-python/setuptools"

PYTHON_MODNAME="deb822.py debian debian_bundle"

src_prepare() {
	sed -e s/__CHANGELOG_VERSION__/${PV}/ setup.py.in > setup.py || die
	distutils_src_prepare
}

src_test() {
	testing() {
		local t
		for t in test_*.py ; do
			PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" "${t}" || return
		done
	}
	cd tests || die
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
