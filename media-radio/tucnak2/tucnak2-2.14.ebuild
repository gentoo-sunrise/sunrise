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
IUSE="alsa ftdi gpm hamlib"

RDEPEND=">=dev-libs/glib-2
	media-libs/libsndfile
	>=media-libs/libsdl-1.2
	alsa? ( media-libs/alsa-lib )
	ftdi? ( dev-embedded/libftdi )
	gpm? ( sys-libs/gpm )
	hamlib? ( media-libs/hamlib )
	>=media-libs/libpng-1.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-doc.diff" \
	    "${FILESDIR}/${P}-appname.diff" \
	    "${FILESDIR}/${P}-config.diff"
	eautoreconf
}


src_compile() {
	econf $(use_with alsa) $(use_with ftdi) \
		$(use_with gpm) $(use_with hamlib) --with-sdl
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	doman debian/tucnak2.1 || die "doman failed"
	dodoc AUTHORS ChangeLog TODO doc/NAVOD.sxw doc/NAVOD.pdf || die "dodoc failed"
}

pkg_postinst() {
	elog "In order to use sound with tucnak2 add yourself to the audio group"
	elog ""
	elog "tucnak2 can be used with the following additional packages:"
	elog "	   media-radio/cwdaemon  : Morse output via code cwdaemon"
	elog "                             (No need to recompile)"
}
