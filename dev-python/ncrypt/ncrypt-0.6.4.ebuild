# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils python

DESCRIPTION="A python wrapper for OpenSSL"
HOMEPAGE="http://tachyon.in/ncrypt/"
SRC_URI="http://fs.tachyon.in.s3.amazonaws.com/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/openssl
	dev-python/pyrex"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

DOCS="website/usage.txt"

src_prepare() {
	epatch "${FILESDIR}/cinit.patch"
}
