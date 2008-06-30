# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Amateur Radio VHF Contest Logbook"
HOMEPAGE="http://tucnak.nagano.cz"
SRC_URI="http://tucnak.nagano.cz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ftdi sdl"

RDEPEND=">=dev-libs/glib-2
	sys-libs/gpm
	media-libs/libsndfile
	media-libs/libpng
	sdl? ( media-libs/libsdl )
	ftdi? ( dev-embedded/libftdi )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-doc.diff" \
	    "${FILESDIR}/${P}-config.diff"
	eautoreconf
}


src_compile() {
	econf $(use_with sdl) $(use_enable ftdi)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog TODO || die "dodoc failed"
}

pkg_postinst() {
	elog "tucnak2 can be used with the following additional packages:"
	elog "	   media-radio/cwdaemon  : Morse output via code cwdaemon"
	elog "                             (No need to recompile)"
}
