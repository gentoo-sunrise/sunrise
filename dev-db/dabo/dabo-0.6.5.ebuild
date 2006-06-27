# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A 3-tier, cross-platform application development framework written in Python atop the wxPython GUI toolkit"
HOMEPAGE="http://dabodev.com/"
SRC_URI="ftp://dabodev.com/dabo/${P}-mac-nix.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
S=${WORKDIR}/${PN}

DEPEND=">=dev-python/setuptools-0.6_alpha9"

RDEPEND=">=dev-python/wxpython-2.5.2.8
	${DEPEND}"

src_install() {
	${python} setup.py install --root=${D} --no-compile \
		--single-version-externally-managed "$@" || die "setup.py install failed"

	dodoc ANNOUNCE AUTHORS ChangeLog README TODO
}
