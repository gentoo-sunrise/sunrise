# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="http://www.milkytracker.net/"
SRC_URI="http://www.milkytracker.net/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="alsa jack"

DEPEND=">=media-libs/libsdl-1.2.0
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_with alsa) $(use_with jack)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS docs/readme_unix
	dohtml docs/MilkyTracker.html docs/FAQ.html docs/ChangeLog.html

	newicon resources/pictures/carton.png milkytracker.png
	make_desktop_entry milkytracker MilkyTracker milkytracker \
		"AudioVideo;Audio;Sequencer"
}

pkg_postinst() {
	einfo "Please check out the documentation saved at:"
	einfo "/usr/share/doc/${PF}/"
}
