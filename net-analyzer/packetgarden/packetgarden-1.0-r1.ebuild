# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base python

MY_P="${P/-/_}_all"

DESCRIPTION="captures information about how you use the internet and use it to grow a private world"
HOMEPAGE="http://selectparks.net/~julian/pg/"
SRC_URI="http://selectparks.net/~julian/pg/dists/${MY_P}.tar.gz -> ${MY_P}-${PVR}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/dpkt
	dev-python/imaging
	dev-python/geoip-python
	dev-python/pypcap
	|| ( >=dev-python/soya-0.13_rc1[openal] =dev-python/soya-0.14 )
	x11-libs/gksu"

S=${WORKDIR}/trunk

PATCHES=( "${FILESDIR}/${P}-launcher.patch"
	"${FILESDIR}/${P}-games-path.patch" )

src_install() {
	newbin stop_capture packetgarden-stop || die
	dobin packetgarden || die
	insinto /usr/share/${PN}
	doins -r config data guide labels logs stats pg_*.py || die
	dodoc README_LINUX.txt || die
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
