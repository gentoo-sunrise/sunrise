# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Plain (stupid) text-based todo manager"
HOMEPAGE="http://requiescant.tuxfamily.org/tofu/index.html"
SRC_URI="http://requiescant.tuxfamily.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl"

src_configure() { true; }

src_install() {
	dodoc CHANGELOG README || die "dodoc failed"
	doman share/* || die "doman failed"
	dobin ${PN} tofuup || die "dobin failed"
}

pkg_postinst() {
	elog "If you are using ${PN}<3.0 you should run tofuup first."
}
