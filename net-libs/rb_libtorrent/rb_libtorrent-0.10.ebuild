# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit eutils autotools

MY_P=${P/rb_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.sourceforge.net/"
SRC_URI="mirror://sourceforge/libtorrent/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

pkg_setup() {
	! built_with_use dev-libs/boost threads && die \
		 "rb_libtorrent needs dev-libs/boost built with threads USE flag"

	# fix for dev-libs/boost thread lib
	ln -sf /usr/lib/libboost_thread-mt.so.1.33.1 /usr/lib/libboost_thread.so
}

src_compile() {
	econf $(use_enable debug) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README
}
