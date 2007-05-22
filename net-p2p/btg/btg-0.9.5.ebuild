# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Linux bittorrent client implemented in C++."
HOMEPAGE="http://btg.berlios.de/"
SRC_URI="mirror://berlios/btg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cppunit debug doc event-callback gtk ncurses session-saving upnp web"

RDEPEND=">=net-libs/rb_libtorrent-0.11
		>=dev-libs/boost-1.33
		>=dev-libs/libsigc++-2
		>=net-libs/gnutls-1.0
		dev-util/dialog
		ncurses? ( >=sys-libs/ncurses-5 )
		gtk? ( >=dev-cpp/gtkmm-2.4 )
		web? ( >=dev-lang/php-5 )
		cppunit? ( dev-util/cppunit )
		upnp? ( net-misc/clinkcc )"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

src_compile() {
	if built_with_use "dev-libs/boost" threads || built_with_use "dev-libs/boost" threads-only ; then
		BOOST_LIBS="--with-boost-iostreams=boost_iostreams-mt \
					--with-boost-filesystem=boost_filesystem-mt \
					--with-boost-thread=boost_thread-mt \
					--with-boost-date-time=boost_date_time-mt \
					--with-boost-program_options=boost_program_options-mt"

		einfo "Using threaded Boost libraries"
	fi

	econf $(use_enable cppunit unittest) \
		$(use_enable debug) \
		$(use_enable event-callback) \
		$(use_enable gtk gui) \
		$(use_enable ncurses cli) \
		$(use_enable upnp) \
		$(use_enable web www) \
		${BOOST_LIBS} || die "econf failed"

	if use doc ; then
		emake doxygen || die "emake doxygen failed"
	fi

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}/btgd.initd" btgd
	newconfd "${FILESDIR}/btgd.confd" btgd

	dodoc AUTHORS ChangeLog README TODO
}

