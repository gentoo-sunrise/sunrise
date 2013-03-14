# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Plain (stupid) text-based todo manager"
HOMEPAGE="http://requiescant.tuxfamily.org/tofu/index.html"
SRC_URI="http://requiescant.tuxfamily.org/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

src_configure() { true; }

src_install() {
	dodoc CHANGELOG README
	doman share/*
	dobin ${PN} tofuup
}

pkg_postinst() {
	elog "If you are using ${PN}<3.0 you should run tofuup first."
}
