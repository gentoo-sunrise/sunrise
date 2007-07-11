# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="http://www.musicpd.org/?page=ncmpc"
ESVN_REPO_URI="https://svn.musicpd.org/ncmpc/branches/tradiaz"
ESVN_PROJECT="ncmpc-svn"
ESVN_BOOTSTRAP="autogen.sh"
LICENSE="GPL-2"
IUSE="artist-screen clock-screen debug key-screen lyrics-screen mouse nls raw-mode search-screen"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses
	dev-util/subversion
	dev-libs/popt
	>=dev-libs/glib-2.4"

src_unpack() {
	subversion_fetch     || die "${ESVN}: unknown problem occurred in subversion_fetch."

	# clean some crappy submitted files
	cd ${S}
	sed -i -e '$D' autogen.sh || die "patching of autogen.sh failed."
	sed -i -e 's:po/Makefile:po/Makefile.in:' configure.ac
	rm po/Makefile.in

	subversion_bootstrap || die "${ESVN}: unknown problem occurred in subversion_bootstrap."
}

src_compile() {
	econf $(use_enable artist-screen)	\
			$(use_enable clock-screen)	\
			$(use_enable debug)			\
			$(use_enable key-screen)	\
			$(use_enable lyrics-screen)	\
			$(use_enable mouse)			\
			$(use_enable nls)			\
			$(use_enable raw-mode)		\
			$(use_enable search-screen)

	emake || die "make failed"
}

src_install() {
	make install DESTDIR=${D} docdir=/usr/share/doc/${PF} \
		|| die "install failed"

	prepalldocs
}
