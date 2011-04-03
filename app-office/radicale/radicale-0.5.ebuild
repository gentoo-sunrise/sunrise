# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="*:2.5"
SUPPORT_PYTHON_ABIS=1

inherit distutils

MY_P="${PN/r/R}-${PV}"

DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="http://www.radicale.org/"
SRC_URI="http://www.radicale.org/src/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ssl"

# the '>=' goes ok, as radicale supports _all_ other python version
# this includes all 3.* versions
DEPEND="ssl? ( >=dev-lang/python-2.6.6[ssl] )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install

	# init file
	newinitd "${FILESDIR}"/radicale.init.d radicale || die

	# config file
	insinto /etc/${PN}
	doins config || die
}
