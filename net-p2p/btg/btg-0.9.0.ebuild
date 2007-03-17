# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Linux bittorrent client implemented in C++."
HOMEPAGE="http://btg.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cppunit debug doc gtk ncurses session-saving"

RDEPEND=">=net-libs/rb_libtorrent-0.10
		>=dev-libs/boost-1.32
		>=dev-libs/libsigc++-2
		ncurses? ( >=sys-libs/ncurses-5 )
		gtk? ( >=dev-cpp/gtkmm-2.4 )
		cppunit? ( dev-util/cppunit )"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

src_compile() {
	if built_with_use "dev-libs/boost" threads || use built_with_use "dev-libs/boost" threads-only ; then
		BOOST_LIBS="--with-boost-iostreams=boost_iostreams-mt \
					--with-boost-filesystem=boost_filesystem-mt \
					--with-boost-thread=boost_thread-mt \
					--with-boost-date-time=boost_date_time-mt \
					--with-boost-program_options=boost_program_options-mt"

		einfo "Using threaded Boost libraries"
	fi

	econf $(use_enable debug) \
		$(use_enable ncurses cli) \
		$(use_enable gtk gui) \
		$(use_enable cppunit) \
		$(use_enable session-saving) \
		${BOOST_LIBS}

	if use doc ; then
		emake doxygen || die 'generating doc failed'
	fi

	emake || die 'compile failed'
}

src_install() {
	emake DESTDIR="${D}" install || die 'install failed'

	dodoc AUTHORS ChangeLog README TODO
}

