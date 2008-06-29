# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="lightweight low-dependency web interface to mpd"
HOMEPAGE="http://ion0.com/davemp/"
SRC_URI="http://ion0.com/davemp/downloads/files/${P}.tar.gz"

LICENSE="CCPL-Attribution-NonCommercial-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/JSON-XS
	dev-perl/HTTP-Server-Simple
	dev-perl/Class-Accessor
	media-sound/mpd"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's@themeroot = ./themes@themeroot=/usr/share/davemp/themes@' davemp.conf || die "sed failed"
	sed -i -e "s@use lib './lib'@use lib '/usr/$(get_libdir)/davemp/'@" davempd.pl || die "sed failed"
}

src_install() {
	doinitd "${FILESDIR}"/davemp
	insinto /usr/share/${PN}
	doins -r themes
	insinto /usr/$(get_libdir)/${PN}
	doins -r lib/*
	insinto /etc
	doins davemp.conf
	dobin davempd.pl
	dodoc README Changelog
}
