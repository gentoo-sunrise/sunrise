# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

DESCRIPTION="Film-Quality Vector Animation (core engine)"
HOMEPAGE="http://www.synfig.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc dv examples ffmpeg fontconfig imagemagick jpeg nls openexr truetype"

DEPEND=">=dev-libs/libsigc++-1.2
	dev-cpp/libxmlpp
	media-libs/libpng
	>=dev-cpp/ETL-0.04.12
	ffmpeg? ( media-video/ffmpeg )
	openexr? ( media-libs/openexr )
	fontconfig? ( media-libs/fontconfig )
	truetype? ( media-libs/freetype:2 )
	jpeg? ( media-libs/jpeg )
	nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}
	dv? ( media-libs/libdv )
	imagemagick? ( media-gfx/imagemagick )"

src_compile() {
	econf $(use_with ffmpeg) \
		$(use_with ffmpeg libavcodec) \
		$(use_with fontconfig) \
		$(use_with imagemagick) \
		$(use_with dv libdv) \
		$(use_with openexr ) \
		$(use_with truetype freetype) \
		$(use_with jpeg) \
		$(use_enable nls)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"

	if use doc; then
		dodoc doc/*.txt || die "dodoc failed"
	fi

	if use examples; then
		docinto examples
		dodoc examples/*.sifz || die "dodoc examples failed"
	fi
}
