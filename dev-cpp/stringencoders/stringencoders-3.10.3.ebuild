# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

MY_P="${PN}-v${PV}"
DESCRIPTION="A collection of high performance c-string transformations"
HOMEPAGE="http://code.google.com/p/stringencoders/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}
DOCS=( AUTHORS ChangeLog NEWS README )

# default `make check` doesn't work
src_test() {
	emake test || die
}
