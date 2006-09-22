# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit eutils

DESCRIPTION="qBittorrent is a BitTorrent client in C++ and Qt."
HOMEPAGE="http://www.qbittorrent.org/"
SRC_URI="mirror://sourceforge/qbittorrent/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"


RDEPEND=">=x11-libs/qt-4.1
	>dev-lang/python-2.3
	dev-libs/boost
	>=net-libs/rb_libtorrent-0.10
	net-misc/curl"

DEPEND="${RDEPEND}"

pkg_setup() {
	if ! built_with_use dev-libs/boost threads; then
		eerror "dev-libs/boost has to be built with threads USE-flag."
		die "Missing threads USE-flag for dev-libs/boost"
	fi
}

src_compile() {
	./configure --prefix=/usr || die "econf failed"

	emake || die "emake failed"

	# sandbox violation patch
	epatch ${FILESDIR}/qbittorrent-0.6.1-sandbox.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dobin src/qbittorrent
	dodoc AUTHORS Changelog NEWS README TODO
}
