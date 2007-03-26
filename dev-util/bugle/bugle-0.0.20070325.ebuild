# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Wolfgang Frisch <xororand@frexx.de>

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit autotools toolchain-funcs

DESCRIPTION="A tool for OpenGL debugging"
HOMEPAGE="http://www.opengl.org/sdk/tools/BuGLe/"
SRC_URI="mirror://sourceforge/bugle/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ffmpeg gtk readline"

DEPEND="ffmpeg? ( media-video/ffmpeg )
	gtk? ( >=x11-libs/gtk+-2.4.0 >=x11-libs/gtkglext-1.0.0 )
	readline? ( sys-libs/readline )
	sys-libs/ncurses"

RDEPEND="${DEPEND}"

src_compile() {
	if [ "$(gcc-version)" == "4.0" ]; then
		die "BuGLe doesn't work with gcc-4.0. Use gcc-3.x or >=gcc-4.1."
	fi

	econf \
		$(use_with ffmpeg) \
		$(use_with readline) \
		$(use_with gtk) \
		$(use_with gtk gtkglext) \
		|| die "econf failed"
	emake DESTDIR="${D}" || die "emake failed"
}

src_install() {
	dodoc README TODO TROUBLESHOOTING FAQ doc/*.{txt,html}
	docinto examples
	dodoc doc/examples/*
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	elog "See man 3 bugle for an introduction to BuGLe."
}
