# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="C++ wrapper for the cairo graphics library."
HOMEPAGE="http://cairographics.org/cairomm"
SRC_URI="http://cairographics.org/snapshots/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=x11-libs/cairo-1.2.0"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		doc? ( app-doc/doxygen )"

src_compile() {
	econf $(use_enable doc docs) || die "econf failed."
	emake || "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog MAINTAINERS NEWS README TODO
}
