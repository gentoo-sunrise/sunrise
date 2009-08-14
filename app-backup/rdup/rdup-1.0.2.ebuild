# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The only backup program that doesn't make backups"
HOMEPAGE="http://www.miek.nl/projects/rdup"
SRC_URI="http://www.miek.nl/projects/${PN}/${P}.tar.bz2"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="app-arch/libarchive
	dev-libs/glib
	dev-libs/libpcre
	dev-libs/nettle
	test? ( dev-util/dejagnu )"
RDEPEND=${DEPEND}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog DESIGN README || die "dodoc failed"
}

pkg_postinst() {
	elog "In rdup 1.0.2, the rdup-simple script is moved from /usr/lib/rdup"
	elog "to /usr/bin. Please be sure to update your scripts or crontabs accordingly."
}
