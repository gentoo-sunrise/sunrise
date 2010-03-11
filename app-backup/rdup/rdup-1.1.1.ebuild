# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Generate a file list suitable for full or incremental backups"
HOMEPAGE="http://www.miek.nl/projects/rdup"
SRC_URI="http://www.miek.nl/projects/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="app-arch/libarchive
	dev-libs/glib
	dev-libs/libpcre
	dev-libs/nettle"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

src_configure() {
	econf $(use_enable debug)
}

src_test() {
	if use debug; then
		ewarn "Test phase skipped, as it is known to fail with USE=\"debug\"."
	else
		default_src_test
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog README RELEASE-NOTES-1.1 || die "dodoc failed"
}
