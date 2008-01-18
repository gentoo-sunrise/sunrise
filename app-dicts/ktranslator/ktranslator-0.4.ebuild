# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="A translation program to KDE"
HOMEPAGE="http://ktranslator.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="festival lowmem ocr"
#Flags to choose which plugins should be compiled
#IUSE="${IUSE} babylon dictd plaintext sdict stardict"
RDEPEND="ocr? ( app-text/gocr )
	festival? ( app-accessibility/festival )"

need-kde 3.3

src_compile() {
	myconf="$(use_enable !lowmem opts)"

	#Handling of flags to choose plugins which should be compiled
	#myconf=${myconf} --with-plugins=$(usev babylon),$(usev dictd),$(usev plaintext),$(usev sdict),$(usev stardict)"

	kde_src_compile
}
