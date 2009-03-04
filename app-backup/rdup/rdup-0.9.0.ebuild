# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="rdup is a utility inspired by rsync and the plan9 way of doing backups."
HOMEPAGE="http://www.miek.nl/projects/rdup"
SRC_URI="http://www.miek.nl/projects/${PN}/${P}.tar.bz2"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="path-encryption"

DEPEND="app-arch/libarchive
	dev-libs/glib
	dev-libs/libpcre
	path-encryption? ( dev-libs/nettle )"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure-ac.patch"

	eautoreconf
}

src_compile() {
	econf $(use_with path-encryption nettle )

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dosym ../lib/rdup/rdup-simple.sh /usr/bin/rdup-simple || die "dosym failed"

	dodoc AUTHORS ChangeLog DESIGN README || die "dodoc failed"
}
