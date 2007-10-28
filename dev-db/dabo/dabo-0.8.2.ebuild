# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils multilib

DESCRIPTION="A 3-tier, cross-platform application development framework written in Python atop the wxPython GUI toolkit"
HOMEPAGE="http://dabodev.com/"
SRC_URI="ftp://dabodev.com/dabo/${P}-mac-nix.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_alpha9"

RDEPEND=">=dev-python/wxpython-2.6.1.1
	>=dev-db/sqlite-3.0
	>=dev-python/pysqlite-2.0
	${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	distutils_python_version
	${python} setup.py install --root=${D} --no-compile \
		--single-version-externally-managed "$@" \
		--install-data="/usr/$(get_libdir)/python${PYVER}/site-packages/" \
		|| die "setup.py install failed"

	dodoc ANNOUNCE AUTHORS ChangeLog README TODO
}
