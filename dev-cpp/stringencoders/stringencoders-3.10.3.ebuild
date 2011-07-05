# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

MY_P="${PN}-v${PV}"
DESCRIPTION="A collection of high performance c-string transformations"
HOMEPAGE="http://code.google.com/p/stringencoders/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-werror.patch

	eautoreconf
}

# default `make check` doesn't work
src_test() {
	emake test
}
