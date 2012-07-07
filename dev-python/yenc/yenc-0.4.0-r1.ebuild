# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_COMPAT="python2_6 python2_7"

inherit eutils python-distutils-ng

DESCRIPTION="A fairly simple module, it provide only raw yEnc encoding/decoding"
HOMEPAGE="http://www.golug.it/yenc.html"
SRC_URI="http://www.golug.it/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare(){
	# Remove forced CFLAG on setup.py
	epatch "${FILESDIR}/${PN}-remove-cflags.patch"
}

python_test() {
	PYTHONPATH="$(ls -d build/lib.*)" \
		"${PYTHON}" test/test.py || die "Test failed."
}

src_install() {
	python-distutils-ng_src_install

	dodoc doc/${PN}-draft.1.3.txt
}