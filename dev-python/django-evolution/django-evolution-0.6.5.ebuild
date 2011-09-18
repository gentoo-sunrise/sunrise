# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SUPPORT_PYTHON_ABIS=1

inherit distutils

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Track changes in database models over time, and update the db to reflect them"
HOMEPAGE="http://code.google.com/p/django-evolution/"
SRC_URI="mirror://pypi/d/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# TODO: run the tests
	rm -r tests || die
	distutils_src_prepare
}
