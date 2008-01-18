# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

MY_P="${P/-/_}_all"

DESCRIPTION="captures information about how you use the internet and use it to grow a private world"
HOMEPAGE="http://www.packetgarden.com/"
SRC_URI="http://selectparks.net/~julian/pg/dists/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/dpkt
	dev-python/imaging
	dev-python/geoip-python
	dev-python/pypcap
	>=dev-python/soya-0.13_rc1
	x11-libs/gksu"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! built_with_use dev-python/soya openal ; then
		eerror "${PN} needs dev-python/soya built with openal USE flag enabled."
		die "dev-python/soya without openal"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-launcher.patch"
	epatch "${FILESDIR}/${P}-games-path.patch"
}

src_install() {
	newbin stop_capture packetgarden-stop
	dobin packetgarden
	insinto /usr/share/${PN}
	doins -r config data guide labels logs stats pg_*.py
	dodoc README_LINUX.txt
	keepdir /usr/share/${PN}/data/images/screenshots
}

pkg_postinst() {
	python_mod_optimize "${ROOT}/usr/share/${PN}"
	elog
	elog "In order to get a good performance it is very recomended"
	elog "to install dev-python/psyco"
	elog
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}/usr/share/${PN}"
}
