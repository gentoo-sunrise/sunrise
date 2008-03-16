# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Library for SSA/ASS subtitles rendering"
HOMEPAGE="http://sourceforge.net/projects/libass"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="enca iconv png"

RDEPEND=">=media-libs/freetype-2.1
	media-libs/fontconfig
	enca? ( app-i18n/enca )
	iconv? ( virtual/libiconv )
	png? ( media-libs/libpng )"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}_automagic.patch
	eautoreconf
}

src_compile() {
	econf \
	$(use_with enca) \
	$(use_with iconv) \
	$(use_with png)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
