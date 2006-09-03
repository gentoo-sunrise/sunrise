# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="Jailkit allows to easily put programs and users in a chrooted environment"
HOMEPAGE="http://olivier.sessink.nl/jailkit/"
SRC_URI="http://olivier.sessink.nl/jailkit/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/python"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/jailkit-2.0-destdir.patch"
	epatch "${FILESDIR}/jailkit-2.0-gentoo-sandbox.patch"
}

src_install() {
	# insert /etc/shells from live system before running make install
	insinto /etc
	doins "${ROOT}/etc/shells"
	emake DESTDIR="${D}" install || die "emake install failed"
	doinitd "${FILESDIR}/jailkit"
}
