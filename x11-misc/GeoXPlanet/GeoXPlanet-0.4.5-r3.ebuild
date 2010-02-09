# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base

MY_P="${P}-r2_"
MY_PN="geoxplanet"

DESCRIPTION="Wrapper script to draw traceroutes of current network connections on xplanet images"
HOMEPAGE="http://geoxplanet.sourceforge.net"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2
	mirror://sourceforge/${MY_PN}/geoip.db.zip"

LICENSE="GPL-1 MAXMIND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xinerama"

RDEPEND="x11-misc/xplanet
	dev-python/pygtk
	xinerama? ( media-gfx/imagemagick )
	dev-lang/python[sqlite]"
DEPEND="${RDEPEND}
	app-arch/unzip"

PATCHES=( "${FILESDIR}/${P}.patch" )

src_install() {
	local shrdir="/usr/share/${MY_PN}"

	dobin "${FILESDIR}/${MY_PN}" || die

	cd "${WORKDIR}"
	insinto ${shrdir}

	doins geoip.db || die
	newdoc README README.geoip || die

	cd "${S}"
	doins -r arcFiles defaults src temp templates || die
	fperms 0755 ${shrdir}/src/{GeoXPlanet,configGUI}.py || die

	dodoc CHANGELOG CONFIG_OPTIONS README || die
}

pkg_postinst() {
	ewarn "GeoXPlanet will show configuration dialog only at first launch,"
	ewarn "but you can type 'geoxplanet -C' to use it later."
}
