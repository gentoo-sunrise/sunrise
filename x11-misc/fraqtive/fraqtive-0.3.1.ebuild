# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Fraqtive is a KDE-based program for interactively drawing Mandelbrot and Julia fractals"
HOMEPAGE="http://fraqtive.mimec.org/"
SRC_URI="http://fraqtive.mimec.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# opengl useflag removed because fraqtive does not build without it
IUSE=""

need-kde 3.3

src_compile() {
	local myconf="${myconf} \
		$(use_with arts)"

	kde_src_compile || die "kde_src_compile failed"
}
