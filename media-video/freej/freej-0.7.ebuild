# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/freej/freej-0.7.ebuild,v 1.3 2005/11/13 18:08:38 lu_zero Exp $

inherit eutils

DESCRIPTION="A unified framework for realtime video processing"
HOMEPAGE="http://freej.dyne.org/"
SRC_URI="ftp://freej.dyne.org/freej/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="v4l debug"

DEPEND=">=media-libs/libsdl-1.2.0
	>=media-libs/libpng-1.2.0
	>=media-libs/freetype-2
	media-video/ffmpeg
	sys-libs/slang"

src_unpack() {
	unpack ${A}
	cd ${S}

	# fixes missing errno defines
	epatch ${FILESDIR}/${P}-errno.patch

	# fixes bad hacking with type casting
	epatch ${FILESDIR}/${P}-fastmemcpy.patch

	# fixes some v4l defines
	epatch ${FILESDIR}/${P}-v4l.patch

	# fixes gcc 4.1 compatibility
	epatch ${FILESDIR}/${P}-gcc41.patch
}

src_compile() {

	# patch the doc path
	sed -i -e "s:doc/\${PACKAGE}-\${VERSION}:share/doc/${PF}:" Makefile.in || die "doc path patching failed!"

	econf \
	$(use_enable avi) \
	$(use_enable v4l) \
	$(use_enable debug) \
	|| die "econf failed!"

	# give us custom CFLAGS
	sed -i \
	-e "s:^CFLAGS = .*:CFLAGS = -D_REENTRANT ${CFLAGS}:" \
	-e "s:^CXXFLAGS = .*:CXXFLAGS = -D_REENTRANT ${CXXFLAGS}:" ${S}/src/Makefile \
	|| die "Could not patch custom CFLAGS!"

	emake || die "emake failed"
}

src_install() {
	einstall || die
	dodoc FreeJ_Tutorial.pdf
}
