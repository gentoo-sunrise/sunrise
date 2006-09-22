# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit eutils

DESCRIPTION="rb_libtorrent is a BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.sourceforge.net/"
SRC_URI="mirror://sourceforge/libtorrent/libtorrent-${PV}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="debug"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}"

pkg_setup() {
	! built_with_use dev-libs/boost threads && die \
		 "rb_libtorrent needs dev-libs/boost built with threads USE flag"

	# fix for dev-libs/boost thread lib
	ln -sf /usr/lib/libboost_thread-mt.so.1.33.1 /usr/lib/libboost_thread.so
}

src_compile() {
	cd $WORKDIR/libtorrent-${PV}

	econf $(use_enable debug) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	cd $WORKDIR/libtorrent-${PV}

	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README
}
