# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A shell-level interface to TCP sockets"
HOMEPAGE="http://www.jnickelsen.de/socket/"
SRC_URI="http://www.jnickelsen.de/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dobin socket
	doman socket.1
	dodoc BLURB CHANGES README
	docinto example-scripts
	dodoc scripts/*
}
