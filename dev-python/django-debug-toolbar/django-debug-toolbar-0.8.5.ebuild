# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="A set of panels that display debug information about the current request/response in django"
HOMEPAGE="http://robhudson.github.com/django-debug-toolbar/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-python/django"
DEPEND=""

src_prepare() {
	sed -ie "s/'ez_setup'/'ez_setup','example'/" setup.py || die
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r example || die "Installation of examples failed"
	fi
}
