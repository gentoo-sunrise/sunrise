# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="python? 2"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils python toolchain-funcs

DESCRIPTION="UPnP client library and a simple UPnP client"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"
HOMEPAGE="http://miniupnp.free.fr/"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="python"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.diff
	use python && distutils_src_prepare
}

src_compile() {
	tc-export CC
	emake || die
	use python && distutils_src_compile
}

src_install() {
	emake PREFIX="${D}" install || die "install failed"
	dodoc README Changelog.txt || die "install failed"
	doman man3/* || die "install failed"
	use python && distutils_src_install
}
