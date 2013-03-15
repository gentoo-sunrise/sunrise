# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

MY_P=PottyMouth-${PV}
DESCRIPTION="A python library that scrubs untrusted text to valid, nice-looking, completely safe XHTML"
HOMEPAGE="http://glyphobet.net/pottymouth/"
SRC_URI="http://dev.gentooexperimental.org/~dreeevil/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/${MY_P}

DOCS="readme.html"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.1.2-fix-setup.patch" || die
}
