# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils distutils python

DESCRIPTION="A Python module for working with OpenPGP messages"
HOMEPAGE="https://launchpad.net/pygpgme"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-crypt/gpgme"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="gpgme"

src_prepare() {
	epatch "${FILESDIR}/${P}-include-dir.patch"
	distutils_src_prepare
}
