# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit eutils autotools

DESCRIPTION="BitTorrent library written in C++ for *nix."
HOMEPAGE="http://www.rasterbar.com/products/libtorrent/"
SRC_URI="http://www.rasterbar.com/products/libtorrent/libtorrent-0.11-rc2.tar.gz"

MY_PN="${PN/rb_/}"
MY_PV="${PV/_rc2/}"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

src_compile() {
	# If threads were used to build boost, the library files will have a suffix.
	if built_with_use "dev-libs/boost" threads || use built_with_use "dev-libs/boost" threads-only ; then
		BOOST_LIBS="--with-boost-date-time=mt --with-boost-filesystem=mt --with-boost-thread=mt --with-boost-regex=mt --with-boost-program_options=mt"
	else
		die "rb_libtorrent needs dev-libs/boost built with threads USE flag"
	fi

	econf $(use_enable debug) ${BOOST_LIBS} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog AUTHORS NEWS README
}
