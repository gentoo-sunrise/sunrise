# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

ESVN_REPO_URI="https://svn.musicpd.org/ncmpc/branches/tradiaz"
ESVN_BOOTSTRAP="autogen.sh"

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="http://www.musicpd.org/?page=ncmpc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="artist-screen clock-screen debug key-screen lyrics-screen mouse nls raw-mode search-screen"

RDEPEND="dev-libs/expat
	>=dev-libs/glib-2.4
	net-misc/curl
	sys-libs/ncurses"

	# FIXME: curl and expat are only needed for lyrics-screen
	# Unfortunately, they are linked to whenever found
	# lyrics-screen? ( dev-libs/expat net-misc/curl )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	subversion_fetch

	cd "${S}"

	# No need to configure during boostrap.
	sed -i -e '/.\/configure/d' autogen.sh || die "sed failed"

	# Do not enter po directory.
	sed -i -e 's/ po\/Makefile//' configure.ac || die "sed failed"
	sed -i -e '/\\$/{N;s/\\\n  po//}' Makefile.am || die "sed failed"

	subversion_bootstrap
}

src_compile() {
	econf $(use_enable artist-screen) \
		$(use_enable clock-screen) \
		$(use_enable debug) \
		$(use_enable key-screen) \
		$(use_enable lyrics-screen) \
		$(use_enable mouse) \
		$(use_enable nls) \
		$(use_enable raw-mode) \
		$(use_enable search-screen) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install \
		|| die "emake install failed"
}
