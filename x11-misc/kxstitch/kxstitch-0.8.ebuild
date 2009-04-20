# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit kde

DESCRIPTION="A program to create cross stitch patterns and charts"
HOMEPAGE="http://kxstitch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick scanner"

DEPEND="imagemagick? ( media-gfx/imagemagick[-nocxx] )
	scanner? ( media-gfx/sane-backends )"
RDEPEND="${DEPEND}"
