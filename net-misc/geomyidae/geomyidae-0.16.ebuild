# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="A daemon to serve the gopher protocol"
HOMEPAGE="http://r-36.net/src/Geomyidae/"
SRC_URI="http://r-36.net/src/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_setup(){
	enewgroup gopherd
	enewuser gopherd -1 -1 /var/gopher gopherd
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dosbin ${PN} || die

	newinitd rc.d/Gentoo.init.d ${PN} || die
	newconfd rc.d/Gentoo.conf.d ${PN} || die

	insinto /var/gopher
	doins index.gph || die
	fowners -R root.gopherd /var/gopher || die
	fperms -R g=rX,o=rX /var/gopher || die

	doman ${PN}.8 || die
	dodoc README || die
}
