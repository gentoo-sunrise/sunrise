# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Generate a file list suitable for full or incremental backups"
HOMEPAGE="http://www.miek.nl/projects/rdup"
SRC_URI="http://www.miek.nl/projects/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

RDEPEND="
	app-arch/libarchive
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/nettle"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

src_prepare() {
	default_src_prepare
	# see https://github.com/miekg/rdup/pull/4
	epatch "${FILESDIR}/${P}-fix-strip.patch"
	sed -i -e 's/ -Werror//' GNUmakefile.in || die "Failed to fix Makefile"
}

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
