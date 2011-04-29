# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Subtitle script creator/editor"
HOMEPAGE="http://www.sabbu.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls oss"

RDEPEND="
	nls? ( sys-devel/gettext )
	x11-libs/gtk+:2
	media-libs/libsndfile"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	# none of the current ffmpeg works here
	econf \
		--without-ffmpeg \
		$(use_enable nls) \
		$(use_with oss)
}
