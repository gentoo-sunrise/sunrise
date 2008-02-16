# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Helpful python wrapper to the os.path module"
HOMEPAGE="http://www.jorendorff.com/articles/python/path"
SRC_URI="http://www.jorendorff.com/articles/python/${PN}/${P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_test() {
	${python} test_path.py || die "test failed"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't install test_path.py
	sed -i \
		-e "s/, 'test_path'//" \
		setup.py || die "sed failed"
}
