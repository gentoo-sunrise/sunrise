# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib

DESCRIPTION="Lightweight low-dependency web interface to mpd"
HOMEPAGE="http://ion0.com/davemp/"
SRC_URI="http://ion0.com/davemp/downloads/files/${P}.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/JSON-XS
	dev-perl/HTTP-Server-Simple
	dev-perl/Class-Accessor"

src_prepare() {
	epatch "${FILESDIR}"/${P}-run-in-foreground.diff
	epatch "${FILESDIR}"/${P}-json-fix.diff
	sed -i -e 's@themeroot = ./themes@themeroot=/usr/share/davemp/themes@' davemp.conf || die
	sed -i -e "s@use lib './lib'@use lib '/usr/$(get_libdir)/davemp/'@" davempd.pl || die
}

src_install() {
	dobin davempd.pl || die
	doinitd "${FILESDIR}"/davemp || die
	dodoc README Changelog || die

	insinto /usr/share/${PN}
	doins -r themes || die
	insinto /usr/$(get_libdir)/${PN}
	doins -r lib/* || die
	insinto /etc
	doins davemp.conf || die
}

pkg_postinst() {
	enewuser mpd ""	"" "/var/lib/mpd" audio
}
