# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Yet another CW trainer for Linux/Unix"
HOMEPAGE="http://fkurz.net/ham/qrq.html"
SRC_URI="http://fkurz.net/ham/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# avoid prestripping of 'qrq' binary
	sed -i -e "s/install -s -m/install -m/" Makefile || die "patch failed"
}

src_install() {
	emake DESTDIR="${D}/usr" install || die "install failed"
	dodoc CHANGELOG README || die "dodoc failed"
}

