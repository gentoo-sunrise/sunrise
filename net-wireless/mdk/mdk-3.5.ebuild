# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${PN}${PV/./-v}"
DESCRIPTION="Tool to bruteforce the SSID"
HOMEPAGE="http://homepages.tu-darmstadt.de/~p_larbig/wlan"
SRC_URI="${HOMEPAGE}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-Makefile.patch
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || \
		die "installation of ${PN} failed"

	insinto /usr/share/${PN}
	doins -r useful_files || die "no helpers"

	dohtml docs/* || die "no html docs"
	dodoc AUTHORS CHANGELOG TODO || die "nothing to read"
}
