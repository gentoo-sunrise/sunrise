# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A reference open-source implementation of DLNA (Digital Living Network Alliance) standards."
HOMEPAGE="http://libdlna.geexbox.org"
SRC_URI="http://libdlna.geexbox.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	# I can't use econf
	# --host is not implemented in ./configure file
	./configure \
		--prefix=/usr \
		|| die "./configure failed"
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc README FAQ CHANGELOG
}
