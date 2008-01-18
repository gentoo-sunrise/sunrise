# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Subtitle script creator/editor"
HOMEPAGE="http://www.sabbu.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ffmpeg nls oss"

RDEPEND="ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20051120 )
	nls? ( sys-devel/gettext )
	>=x11-libs/gtk+-2.6
	media-libs/libsndfile"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-new-ffmpeg.patch"
}

src_compile() {
	econf $(use_with ffmpeg) \
		$(use_enable nls) \
		$(use_with oss) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
