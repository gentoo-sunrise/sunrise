# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="qmqtool is a qmail queue manipulation program"
HOMEPAGE="http://jeremy.kister.net/code/qmqtool/"
SRC_URI="http://jeremy.kister.net/code/qmqtool/${PN}-current.tgz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/qmail
	dev-lang/perl"
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/qmqtool-perlpath.patch"
}

src_install() {
	dodoc README FAQ ChangeLog

	docinto contrib/argus
	dodoc contrib/argus/*

	docinto contrib/cricket
	dodoc contrib/cricket/*

	dobin qmqtool
}
