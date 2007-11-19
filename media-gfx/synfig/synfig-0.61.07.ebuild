# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Synfig: Film-Quality Vector Animation (core engine)"
HOMEPAGE="http://www.synfig.com/"
SRC_URI="mirror://sourceforge/synfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="imagemagick ffmpeg dv openexr truetype jpeg tiff png fontconfig"

DEPEND=">=dev-libs/libsigc++-2.0.0
	>=dev-cpp/libxmlpp-2.6.1
	>=dev-cpp/ETL-0.04.10
	ffmpeg? ( media-video/ffmpeg )
	openexr? ( media-libs/openexr )
	truetype? ( >=media-libs/freetype-2.1.9 )
	fontconfig? ( media-libs/fontconfig )
	jpeg? ( media-libs/jpeg )
	tiff? ( media-libs/tiff )
	png? ( media-libs/libpng )"

RDEPEND="${DEPEND}
	dv? ( media-libs/libdv )
	imagemagick? ( media-gfx/imagemagick )"

src_compile() {
	econf \
		--with-libdv \
		--with-imagemagick  \
		$(use_with ffmpeg ) \
		$(use_with openexr ) \
		$(use_with truetype freetype) \
		|| die "Configure failed!"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
	dodoc doc/*.txt
	insinto /usr/share/${PN}/examples
	doins examples/*.sif
}

